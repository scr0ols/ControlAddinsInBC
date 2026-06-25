//JOA006+ 
page 60005 "Customer Notes"
{
    Caption = 'New Note';
    PageType = Card;
    SourceTable = "Customer Notes";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Note informations';
                field("Note No."; Rec."Note No.")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Visible = false;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    Visible = false;
                }
                field("Modification Date"; Rec."Modification Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Modification Date field.';
                    Visible = false;
                }
            }
            group(Body)
            {
                Caption = 'Note';
                //Adding control add-in to webpage
                usercontrol(EditCtl; CKEditorNotes)
                {
                    ApplicationArea = All;
                    //The control add in is loaded on the page
                    trigger ControlReady()
                    begin
                        EditorAddInInitialized := true;
                        //Lets load create and append the text editor
                        CurrPage.EditCtl.Init();
                    end;
                    //After the text editor is created this trigger will run
                    trigger OnAfterInit()
                    begin
                        EditorReady := true;
                        if Rec."Note Content" <> '' then
                            //Load the editor with the last inserted content
                            CurrPage.EditCtl.Load(Rec."Note Content")
                        else
                            //Load the editor with no text
                            CurrPage.EditCtl.Load('');
                        //Lets give the same state to the editor as the Editability of the page, in other words, if the page is editable we can insert text in 
                        //editor, if not we will set the editor to read only mode
                        CurrPage.EditCtl.SetReadOnly(not CurrPage.Editable);
                    end;
                    //trigger that tell us that something has change
                    trigger ContentChanged()
                    begin
                        CurrPage.EditCtl.RequestSave();
                    end;
                    //saving the content to our current record
                    trigger SaveRequested(data: Text)
                    begin
                        Rec."Note Content" := data;
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if EditorReady then begin
            EditorReady := false;
            if not EditorAddInInitialized then
                exit;
            CurrPage.EditCtl.Init();
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        DialogResult: Boolean;
        DialogTxt: Label 'If you close without a title the note won´te be saved. Are you sure?';
        lAction: Action;
        CustomerNotes: Record "Customer Notes";
    begin
        if not (Rec."Note created") then
            Rec."Note created" := true;


        Rec."Modification Date" := CurrentDateTime();
        Rec.Modify();

        if not (Rec.Title <> '') then begin
            DialogResult := Dialog.Confirm(DialogTxt, false);
            case DialogResult of
                true:
                    begin
                        CustomerNotes.Reset();
                        if CustomerNotes.Get(Rec."Note No.") then
                            CustomerNotes.Delete();
                    end;
                false:
                    begin
                        Page.Run(60005, Rec);
                    end;
            end;

        end;
    end;

    var
        EditorReady: Boolean;
        EditorAddInInitialized: Boolean;
}
//JOA006-
