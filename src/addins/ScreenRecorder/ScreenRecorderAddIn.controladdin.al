//JOA005+ 
controladdin "SCR Screen Recorder AddIn"
{
    //Reserved area by the control add-in.
    RequestedHeight = 450;
    RequestedWidth = 788;

    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    //Script to include in the control add-in.  
    Scripts = 'src\addins\ScreenRecorder\ScreenRecorderScript.js';
    //This script is invoked when the webpage (in this case page 50140 "SCR Screen Recorder") with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';

    //In the ControlReady_startup.js we call this event to initialize the control add-in. This event will invoke the trigger ControlReady() in "SCR Screen Recorder" page.
    event ControlReady()
    //Event to change buttons visibility on control add-in page when the user hits the cancel button
    event ChangeButtonsStateCancelClick()
    //Event to change buttons visibility on control add-in page when the user hits the stop button
    event ChangeButtonsStateStopClick()
    //Event to change buttons visibility on control add-in page when the user hits the start button
    event ChangeButtonsStateStartClick()
    //Event to change buttons visibility on control add-in page when the user hits the download button
    event ChangeButtonsStateDownloadClick()

    //Return the location of the recorded attachment
    event AttachmentReady(attachmentLocation: Text)

    //Procedure to start the MediaRecorder and start recording tracks
    procedure startRecord()
    //Procedure to stop the tracks recording
    procedure stopScreen()
    //Procedure that will download the recorded tracks in mp4 format
    procedure downloadVideo()
}
//JOA005-