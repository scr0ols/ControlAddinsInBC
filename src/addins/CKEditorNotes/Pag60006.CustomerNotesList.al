//JOA006+ 
page 60006 "Customer Notes List"
{
    Caption = 'Customer Notes';
    DataCaptionExpression = CurrNoteCaption;
    PageType = List;
    SourceTable = "Customer Notes";
    UsageCategory = Administration;
    ApplicationArea = All;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(CustomerNotes)
            {
                field("Note No."; Rec."Note No.")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID field.';
                    trigger OnDrillDown()
                    begin
                        Page.Run(60005, Rec);
                    end;

                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Modification Date"; Rec."Modification Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Modification Date field.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrNoteCaption := Format(Rec."Note No.");
    end;

    var
        CurrNoteCaption: Text;
}
//JOA006-