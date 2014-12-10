param(
[Parameter(Mandatory = $false, HelpMessage = "the url of deployworkflow invoker web service")]
[ValidateNotNullOrEmpty()]
[string]$DeployWorkflowInvokerUrl,

[Parameter(Mandatory = $true, HelpMessage = "the path of workflow xaml file")]
[ValidateNotNullOrEmpty()]
[string]$WorkflowXamlFile,

[Parameter(Mandatory = $true, HelpMessage = "the path of settingsFile")]
[ValidateNotNullOrEmpty()]
[string]$SettingsXmlFile,

[Parameter(Mandatory = $false, HelpMessage = "the receiver email address of result")]
[ValidateNotNullOrEmpty()]
[string]$EmailTo,

[Parameter(Mandatory = $true, HelpMessage = "The project name that you want to deploy")]
[ValidateNotNullOrEmpty()]
[string]$ProjName,

[Parameter(Mandatory = $true, HelpMessage = "The Enviroment that you want to deploy the services to")]
[ValidateNotNullOrEmpty()]
[string]$DeployEnv
)

Function Send-HttpRequest
{
    param([string]$url, [string]$method="GET", [string]$body="")

    $Script:Http.Open($method, $url, $false)
    $Script:Http.SetRequestHeader("Content-Type", "application/JSON")
    $Script:Http.Send($body)
    return $Script:Http.ResponseText
}

Function Write-StepSeperator
{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$str
    )

    Write-Host -ForegroundColor Green $str;
}

Function Write-ErrorExit
{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$str
    )

    Write-Host -ForegroundColor Red $str;
    exit -1
}

$Http = New-Object -com 'WinHttp.WinHttpRequest.5.1'

try{
    if([string]::IsNullOrEmpty($DeployWorkflowInvokerUrl))
    {
        $DeployWorkflowInvokerUrl = "http://sqlpod091-14.redmond.corp.microsoft.com:8082"
        #$DeployWorkflowInvokerUrl = "http://localhost:8082"
    }

    $InvokeDeployworkfowUrl = "$DeployWorkflowInvokerUrl/Deployment/InvokeWorkflow";
    $CheckWorkflowStatusUrl = "$DeployWorkflowInvokerUrl/Deployment/CheckWorkflowStatus";
    
    if(![System.IO.File]::Exists($WorkflowXamlFile))
    {
        Write-ErrorExit "$WorkflowXamlFile not exist";
    }

    if(![System.IO.File]::Exists($SettingsXmlFile))
    {
        Write-ErrorExit "$settingsXmlFile not exist";
    }

    $CurUser = $env:username;

    if([System.String]::IsNullOrEmpty($EmailTo))
    {
        $EmailTo = $CurUser;
    }

    if(!$EmailTo.EndsWith('@microsoft.com'))
    {
        $EmailTo += '@microsoft.com';
    }

    $mailSender = 'rdauto@microsoft.com'
    $mailReceiver = $EmailTo
    $mailSubject = "Deployment of <$ProjName-$DeployEnv> started."
    $mailUsername = "redmond\rdauto"
    $mailPassword = ConvertTo-SecureString "FCTest#$%" -AsPlainText -Force
    $mailCredential = New-Object System.Management.Automation.PSCredential($mailUsername, $mailPassword)

    Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -Credential $mailCredential
    
    $invokeRequestData = New-Object PSObject
    Add-Member -NotePropertyName 'WorkflowXamlPath'  -NotePropertyValue "$WorkflowXamlFile"  -InputObject $invokeRequestData
    Add-Member -NotePropertyName 'SettingsXmlPath' -NotePropertyValue "$SettingsXmlFile" -InputObject $invokeRequestData

    $invokeJsonStr = ConvertTo-Json $invokeRequestData;

    Write-StepSeperator "--- sending request to invoke deployment"
    Write-Host "workflowxaml:$WorkflowXamlFile"
    Write-Host "settingsxml:$SettingsXmlFile"

    [int]$retriedTimes = 0;
    while($true -and ($retriedTimes -le 3))
    {
        try{
            $invokeResponse = Send-HttpRequest $InvokeDeployworkfowUrl "POST" $invokeJsonStr;
            if(![System.String]::IsNullOrEmpty($invokeResponse))
            {
                break;
            }
        }catch
        {
            $retriedTimes ++;
        
            Write-Host $_.Exception.Message

            Start-Sleep -Seconds 1
        }
    }

    if($retriedTimes -gt 2)
    {
        $mailSubject = "Deployment of <$ProjName-$DeployEnv> failed."
        $mailBody = "failed to send request to invoke deployment workflow, please check the server $DeployWorkflowInvokerUrl"
        Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -BodyAsHtml $mailBody -Credential $mailCredential
    
        Write-ErrorExit "send request of Invoke deployworkflow failed"
    }

    Write-StepSeperator "--- receive the response of invoking"

    $invokeResponseData = ConvertFrom-Json $invokeResponse

    if($invokeResponseData.ResultCode -eq 0 -and ![string]::IsNullOrEmpty($invokeResponseData.InvokerGuid))
    {
        
        Write-Host "invoke deployment workflow successfully"

        Write-StepSeperator "--- sleep for 60 seconds to check the status"

        Start-Sleep -Seconds 60
    
        $invokeGuid = $invokeResponseData.InvokerGuid;

        [int]$timeout = 3600;
        
        [int]$passedTime = 0;
        [int]$retryInterval = 30;

        while($true)
        {
            $checkStatusRequest = New-Object PSObject
            Add-Member -NotePropertyName 'InvokerGuid' -NotePropertyValue "$invokeGuid" -InputObject $checkStatusRequest
            $checkStatusRequestJsonStr = ConvertTo-Json $checkStatusRequest
        
            Write-StepSeperator "--- sending request to check the status of deployment"

            Write-Host "invoker guild: $invokeGuid"

            [int]$retriedTimes = 0;
        
            while($true -and ($retriedTimes -le 3))
            {
                try{
                    $checkStatusResponseStr = Send-HttpRequest $CheckWorkflowStatusUrl "GET" $checkStatusRequestJsonStr;
                    if(![System.String]::IsNullOrEmpty($checkStatusResponseStr))
                    {
                        break;
                    }
                }catch
                {
                    Write-Host $_.Exception.Message
                    $retriedTimes ++;
                    Start-Sleep -Seconds 1
                }
            }

            if($retriedTimes -gt 2)
            {
                
                $mailSubject = "Deployment of <$ProjName-$DeployEnv> can't check status."
                $mailBody = "deployment status unknow because failed to send request to check status, please check the server $DeployWorkflowInvokerUrl"
                Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -BodyAsHtml $mailBody -Credential $mailCredential
    
                Write-ErrorExit "send check status of deployment failed"
            }

            Write-StepSeperator "--- receive the response of checking status"
            
            $checkStatusResponseData = ConvertFrom-Json $checkStatusResponseStr

            switch($checkStatusResponseData.WorkflowStatus.StatusCode)
            {
                # success
                0 {
                    Write-Host "deployment $invokeGuid success"
                    $mailSubject = "Deployment of <$ProjName-$DeployEnv> success."
                    Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -Credential $mailCredential
    
                    exit;
                }

                # failed to submitted to server
                1 {

                    $msg = $checkStatusResponseData.WorkflowStatus.Message;
                    $mailSubject = "Deployment of <$ProjName-$DeployEnv> failed to submit."
                    $mailBody = "The message from server is: $msg"
                    Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -BodyAsHtml $mailBody -Credential $mailCredential    

                    Write-ErrorExit "deployment $invokeGuid submit failed with message: $msg"
                }

                # submitted
                2 {
                    Write-Host "deployment $invokeGuid status: submitted"
                    
                    Write-StepSeperator "--- sleep for $retryInterval seconds"

                    Start-Sleep -Seconds $retryInterval
                }

                # running
                3 {
                    Write-Host "deployment $invokeGuid status: running"
                    
                    Write-StepSeperator "--- sleep for $retryInterval seconds"

                    Start-Sleep -Seconds $retryInterval
                }

                # failed
                4 {
                    $msg = $checkStatusResponseData.WorkflowStatus.Message;

                    $mailSubject = "Deployment of <$ProjName-$DeployEnv> failed."
                    $mailBody = "The message from server is: $msg"
                    Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -BodyAsHtml $mailBody -Credential $mailCredential    

                    Write-ErrorExit "deployment $invokeGuid failed with message: $msg"
                }

                # unknow status
                Default {
                    $msg = $checkStatusResponseData.WorkflowStatus.Message;
                    Write-Host "deployment $invokeGuid unknow status: $msg";
                }
            }

            $passedTime += $retryInterval;
            
            if($passedTime -gt $timeout)
            {
                
                $mailSubject = "Deployment of <$ProjName-$DeployEnv> timeout."
                
                Send-MailMessage -SmtpServer smtphost -From $mailSender -To $mailReceiver -Subject $mailSubject -Credential $mailCredential    

                Write-ErrorExit "deployment $invokeGuid timeout"
            }

        }
    }else
    {
        Write-ErrorExit "invoke deployment $WorkflowXamlFile failed"
    }

}catch
{
    Write-ErrorExit $_.Exception.Message
}
