using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.ApplicationModel;
using Windows.ApplicationModel.Activation;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.Media.SpeechRecognition;
using Windows.Storage;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

using Microsoft.Azure.Devices;
using System.Text;
using System.Threading.Tasks;

namespace Cortana
{
    /// <summary>
    /// Provides application-specific behavior to supplement the default Application class.
    /// </summary>
    sealed partial class App : Application
    {
        static string iotHubUri = "DigiHome.azure-devices.net";
        static string deviceId = "myFirstDevice";
        static string deviceKey = "tDhZSwN5DdiuEm7UZ3Tx/a9QW+1mA3OnCWk3/1HJuYM=";
        static string connectionString = "HostName=DigiHome.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=ziGdamsPxt8Dqy0i0V25Li7XBw7nDbZQM7/kkL9eP6o=";

        /// <summary>
        /// Initializes the singleton application object.  This is the first line of authored code
        /// executed, and as such is the logical equivalent of main() or WinMain().
        /// </summary>
        public App()
        {
            this.InitializeComponent();
            this.Suspending += OnSuspending;
        }

        /// <summary>
        /// Invoked when the application is launched normally by the end user.  Other entry points
        /// will be used such as when the application is launched to open a specific file.
        /// </summary>
        /// <param name="e">Details about the launch request and process.</param>
        protected async override void OnLaunched(LaunchActivatedEventArgs e)
        {
#if DEBUG
            if (System.Diagnostics.Debugger.IsAttached)
            {
                this.DebugSettings.EnableFrameRateCounter = true;
            }
#endif
            Frame rootFrame = Window.Current.Content as Frame;

            // Do not repeat app initialization when the Window already has content,
            // just ensure that the window is active
            /*
            if (rootFrame == null)
            {
                // Create a Frame to act as the navigation context and navigate to the first page
                rootFrame = new Frame();

                rootFrame.NavigationFailed += OnNavigationFailed;

                if (e.PreviousExecutionState == ApplicationExecutionState.Terminated)
                {
                    //TODO: Load state from previously suspended application
                }

                // Place the frame in the current Window
                Window.Current.Content = rootFrame;
            }

            if (e.PrelaunchActivated == false)
            {
                if (rootFrame.Content == null)
                {
                    // When the navigation stack isn't restored navigate to the first page,
                    // configuring the new page by passing required information as a navigation
                    // parameter
                    rootFrame.Navigate(typeof(MainPage), e.Arguments);
                }
                // Ensure the current window is active
                Window.Current.Activate();
            }
            */

            try
            {
                // Install the main VCD. Since there's no simple way to test that the VCD has been imported, or that it's your most recent
                // version, it's not unreasonable to do this upon app load.
                StorageFile vcdStorageFile = await Package.Current.InstalledLocation.GetFileAsync(@"commands.xml");

                await Windows.ApplicationModel.VoiceCommands.VoiceCommandDefinitionManager.InstallCommandDefinitionsFromStorageFileAsync(vcdStorageFile);

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Installing Voice Commands Failed: " + ex.ToString());
            }
        }

        /// <summary>
        /// Invoked when Navigation to a certain page fails
        /// </summary>
        /// <param name="sender">The Frame which failed navigation</param>
        /// <param name="e">Details about the navigation failure</param>
        void OnNavigationFailed(object sender, NavigationFailedEventArgs e)
        {
            throw new Exception("Failed to load Page " + e.SourcePageType.FullName);
        }

        /// <summary>
        /// Invoked when application execution is being suspended.  Application state is saved
        /// without knowing whether the application will be terminated or resumed with the contents
        /// of memory still intact.
        /// </summary>
        /// <param name="sender">The source of the suspend request.</param>
        /// <param name="e">Details about the suspend request.</param>
        private void OnSuspending(object sender, SuspendingEventArgs e)
        {
            var deferral = e.SuspendingOperation.GetDeferral();
            //TODO: Save application state and stop any background activity
            deferral.Complete();
        }

        protected async override void OnActivated(IActivatedEventArgs args)
        {
            base.OnActivated(args);

            if (args.Kind == ActivationKind.VoiceCommand)
            {
                // The arguments can represent many different activation types. Cast it so we can get the
                // parameters we care about out.
                var commandArgs = args as VoiceCommandActivatedEventArgs;

                SpeechRecognitionResult speechRecognitionResult = commandArgs.Result;

                // Get the name of the voice command and the text spoken. See AdventureWorksCommands.xml for
                // the <Command> tags this can be filled with.
                string voiceCommandName = speechRecognitionResult.RulePath[0];
                string textSpoken = speechRecognitionResult.Text;

                // The commandMode is either "voice" or "text", and it indictes how the voice command
                // was entered by the user.
                // Apps should respect "text" mode by providing feedback in silent form.
                string commandMode = speechRecognitionResult.SemanticInterpretation.Properties["commandMode"].FirstOrDefault();

                switch (voiceCommandName)
                {
                    case "switch":
                        // Access the value of the {destination} phrase in the voice command
                        string status = speechRecognitionResult.SemanticInterpretation.Properties["status"].FirstOrDefault();
                        System.Diagnostics.Debug.WriteLine(status);

                        string messageString = "[]";
                        if (status.Equals("打开"))
                        {
                            SendMessage("[{\"port\": 6, \"status\": 0}]");
                            await Task.Delay(10000);
                            SendMessage("[{\"port\": 6, \"status\": 1}]");
                            await Task.Delay(100);

                            SendMessage("[{\"port\": 5, \"status\": 0}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 1}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 0}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 1}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 0}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 1}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 0}]");
                            await Task.Delay(1000);
                            SendMessage("[{\"port\": 5, \"status\": 1}]");
                            await Task.Delay(100);

                            SendMessage("[{\"port\": 13, \"status\": 0}]");
                            await Task.Delay(10000);
                            SendMessage("[{\"port\": 13, \"status\": 1}]");
                        }
                        else if (status.Equals("关闭"))
                        {
                            SendMessage("[{\"port\": 5, \"status\": 1}]");
                            SendMessage("[{\"port\": 6, \"status\": 1}]");
                            SendMessage("[{\"port\": 13, \"status\": 1}]");
                        }

                        break;
                    default:
                        break;
                }
            }
        }

        private async void SendMessage(string messageString)
        {
            var serviceClient = ServiceClient.CreateFromConnectionString(connectionString);
            System.Diagnostics.Debug.WriteLine(messageString);

            var message = new Message(Encoding.ASCII.GetBytes(messageString));
            await serviceClient.SendAsync(deviceId, message);

        }
    }
}
