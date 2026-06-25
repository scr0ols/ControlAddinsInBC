//JOA005+ 
page 60004 "Screen Recorder"
{
    Caption = 'Bug reporting';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            usercontrol(ScreenRecorderControlAddIn; "Screen Recorder AddIn")
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    RecorderAddInInitialized := true;
                end;
                //If something go wrong and we cannot start to record media or if the user click on the cancel
                //button this trigger will be activated
                trigger ChangeButtonsStateCancelClick()
                begin
                    //So in this case lets only show the start recording button
                    ButtonsVisibility_InitSates();
                end;
                //If the media recorder initializes correctly we call this trigger,
                trigger ChangeButtonsStateStartClick()
                begin
                    //We have started the recording so lets only show the cancel button
                    ButtonsVisibility_ClickedStart();
                end;
                //If the user click on the stop button this will be triggered
                trigger ChangeButtonsStateStopClick()
                begin
                    //Lets show the buttons to start recording and download the recorded video
                    ButtonsVisibility_ClickedStop();
                end;
                //If the user click on "Download" button
                trigger ChangeButtonsStateDownloadClick()
                begin
                    //Lets show the buttons to start recording and download the recorded video
                    ButtonsVisibility_ClickedDownload();
                end;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(ScreenRecorder)
            {
                Visible = true;
                Caption = 'Record screen';
                ToolTip = 'Record screen to show bugs and send them to Arquiconsult so we can fix them';
                action(StartRecord)
                {
                    Caption = 'Start screen recording';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Image = Start;
                    Visible = StartRecordingVisibility;
                    trigger OnAction()
                    var
                        Answer: Boolean;
                    begin
                        //This procedure will run the same function on our JS script and start the media recorder
                        if not RecorderAddInInitialized then
                            exit;
                        CurrPage.ScreenRecorderControlAddIn.startRecord();
                    end;
                }
                action(StopRecord)
                {
                    Caption = 'Stop screen recording';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Image = Stop;
                    Visible = StopRecordingVisibility;
                    trigger OnAction()
                    begin
                        //This procedure will run the same function on our JS script and stop the media recorder
                        if not RecorderAddInInitialized then
                            exit;
                        CurrPage.ScreenRecorderControlAddIn.stopScreen();
                    end;
                }
                action(DownloadVideo)
                {
                    Caption = 'Download video';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Image = Download;
                    Visible = DownloadVisibility;
                    trigger OnAction()
                    begin
                        //This procedure will run the same function on our JS script and download the media tracks 
                        if not RecorderAddInInitialized then
                            exit;
                        CurrPage.ScreenRecorderControlAddIn.downloadVideo();
                    end;
                }
            }
        }
    }

    procedure ButtonsVisibility_ClickedStart()
    begin
        StartRecordingVisibility := false;
        StopRecordingVisibility := true;
        DownloadVisibility := false;
    end;

    procedure ButtonsVisibility_ClickedStop()
    begin
        StartRecordingVisibility := true;
        StopRecordingVisibility := false;
        DownloadVisibility := true;
    end;

    procedure ButtonsVisibility_ClickedDownload()
    begin
        StartRecordingVisibility := true;
        StopRecordingVisibility := false;
        DownloadVisibility := true;
    end;

    procedure ButtonsVisibility_InitSates()
    begin
        StartRecordingVisibility := true;
        StopRecordingVisibility := false;
        DownloadVisibility := false;
    end;

    trigger OnOpenPage()
    begin
        if not RecorderAddInInitialized then
            exit;
        ButtonsVisibility_InitSates();
    end;

    var
        StartRecordingVisibility, StopRecordingVisibility, DownloadVisibility : boolean;
        RecorderAddInInitialized: Boolean;
}

//JOA005-