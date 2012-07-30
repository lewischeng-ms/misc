<!DOCTYPE html>
<?php include ("header.php")?>
<?php
if(!($_SERVER['SERVER_PORT'] == 443)){
	echo "为了保证您的帐号安全，必须以https方式访问本页面！";
	return;
}

$htpasswdtool = "D:\\xampp\\apache\\bin\\htpasswdtool.exe";
$htpasswdfile = "D:\\homework\\htpasswd";
function backupfile($file, $username){
	$filename = basename($file);
	$filepath = dirname($file);
	$backpath = $filepath . "\\accountbackup";
	if (!is_dir($backpath)){
		mkdir($backpath);
	}
	$backfile = $backpath . "\\" . $filename . "-" . time() . "-" . $username . "-" . $_SERVER['REMOTE_ADDR'] . "-back";
	copy($file , $backfile);
}
session_start();
if (isset($_SESSION["service-username"])){
	$username = $_SESSION["service-username"];
}else{
	$username = null;
}

$message = "<br />";

if ($_POST){
	$method = $_POST["method"];
	if ($method == "login"){
		$res = 1;
		$password = $_POST["password"];
		if (preg_match("/^[A-z0-9\\@\\:\\;\\.\\-\\,\\!\\+\\_\\?]*$/" , $password) == 0){
			$message="用户名或密码错误！";
		}else{
			system($htpasswdtool . " -authenticate ". strtolower($_POST["username"]) . " " . $password . " " . $htpasswdfile, $res);
			if ($res == 0){
				$username = $_POST["username"];
				$_SESSION["service-username"] = $username;
			}else{
				$message="用户名或密码错误！";
			}
		}
	}else if($method == "logout"){
		$username = null;
		$_SESSION["service-username"] = null;
	}else if($method == "password"){
		$password = $_POST["newpassword"];
		if ($username == null){
			$message="请先登陆！";
		}elseif (strlen($password) < 6){
			$message="密码不能小于6个字符";
		}elseif ($password == "123456"){
			$message="密码不能设置为123456";
		}elseif (preg_match("/^[A-z0-9\\@\\:\\;\\.\\-\\,\\!\\+\\_\\?]*$/", $password) == 0){
			$message="密码中含有非法字符";
		}else{
			$res = -1;
			backupfile($htpasswdfile,$username);
			system($htpasswdtool . " -modify ". strtolower($username) . " " . $password . " " .  $htpasswdfile, $res);
			if ($res == 0){
				$message="密码修改成功！";
			}else{
				$message="修改失败！";
			}
		}
	}
}
?>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>作业帐号服务</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <link href="bootstrap.css" rel="stylesheet">
	<script src="jquery-1.7.min.js"></script>
	<script src="bootstrap-buttons.js"></script>
	<script src="bootstrap-modal.js"></script>
    <style type="text/css">
      body {
        padding-top: 60px;
      }
    </style>

    <link rel="shortcut icon" href="/favicon.ico">
  </head>

  <body>
    <div class="container">

<?php if ($username == null): ?>
	  <div class="row">
        <div class="span-one-third">&nbsp;</div>
        <div class="span-one-third">
		  <div align="center"><h2>用户登陆</h2></div>
		  <br />
		  <form id="form-login" action="homework.php" method="post">
			  <div align="center">帐号：<input type="text" name="username" id="username" /></div>
			  <div align="center">密码：<input type="password" name="password" id="password" /></div>
			  <input type="hidden" name="method" id="method" value="login" />
		  </form>
		  <div align="center"><?php echo $message; ?></div>
		  <div align="center"><button id="btn-login" class="btn primary">登陆</button></div>
        </div>
        <div class="span-one-third">&nbsp;</div>
      </div>
    </div>
	<script>
		$(function() {var btn = $('#btn-login').click(function () {
			$('#form-login').submit();
		})});
	</script>
<?php endif; ?>

<?php if ($username != null): ?>
	  <div class="row">
        <div class="span-one-third">&nbsp;</div>
        <div class="span-one-third">
		  <div align="center"><h2>你好：<?php echo $username;?></h2></div>
		  <br />
		  <form id="form-password" action="homework.php" method="post">
			  <div align="center">新的密码：<input type="password" name="newpassword" id="newpassword" /></div>
			  <div align="center">再次确认：<input type="password" name="confirmpassword" id="confirmpassword" /></div>
			  <input type="hidden" name="method" value="password" />
		  </form>
		  <form id="form-logout" action="homework.php" method="post">
			  <input type="hidden" name="method" value="logout" />
		  </form>
		  <div align="center" id="message"><?php echo $message; ?></div>
		  <div align="center">
			<button id="btn-modify-password" class="btn danger">修改密码</button>
			<button id="btn-logout" class="btn primary">登出</button>
		  </div>
		  <div>
			<br />
			说明：您的密码将以散列密文形式存于服务器中，但是您使用http或ftp方式登陆时，密码可能会以明文形式泄露。
		  </div>
        </div>
        <div class="span-one-third">&nbsp;</div>
      </div>
    </div>
	<script>
		$(function() {var btn1 = $('#btn-modify-password').click(function () {
			if($('#newpassword').val() == ""){
				$("#message")[0].innerHTML = "密码不能为空"
			}else if($('#newpassword').val().length < 6){
				$("#message")[0].innerHTML = "密码不能小于6个字符"
			}else if($('#newpassword').val() != $('#confirmpassword').val()){
				$("#message")[0].innerHTML = "两次输入的密码不一致"
			}else{
				$('#form-password').submit();
			};
		})});
		$(function() {var btn2 = $('#btn-logout').click(function () {
			$('#form-logout').submit();
		})});
	</script>
<?php endif; ?>
  </body>
</html>