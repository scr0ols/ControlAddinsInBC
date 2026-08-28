//JOA007+
page 50165 "SCR Document Signature List"
{
    Caption = 'Document Signatures';
    PageType = List;
    SourceTable = "SCR Document Signature";
    //Entry No. is auto-incremented, so descending on the primary key puts the most recent
    //signature on top without needing a key on "Signed Date".
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Signatures)
            {
                field(DocumentTypeField; DocumentTypeName)
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    Editable = false;
                    ToolTip = 'Specifies the kind of document this signature was captured for.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document this signature belongs to. Drill down to view the signature.';
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the person who signed the document.';
                    trigger OnDrillDown()
                    var
                        SignatureCapturePage: Page "SCR Signature Capture";
                    begin
                        SignatureCapturePage.SetDocument(Rec."Table No.", Rec."Document No.");
                        //The list is a read-only register: viewing from here must not offer
                        //a way to replace the stored signature.
                        SignatureCapturePage.SetViewOnly();
                        SignatureCapturePage.RunModal();
                    end;
                }
                field("Signed Date"; Rec."Signed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the document was signed.';
                }
                field("Signed By User ID"; Rec."Signed By User ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Business Central user that captured the signature.';
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the source document table.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the unique number of the signature entry.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DocumentTypeName := GetTableCaption(Rec."Table No.");
    end;

    //"Table No." is stored as a raw object ID so the table stays generic. Resolving it here
    //keeps the list readable without adding a redundant field to the table.
    local procedure GetTableCaption(TableNo: Integer): Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableNo) then
            exit(AllObjWithCaption."Object Caption");
        //Source table no longer installed: showing the ID beats showing nothing.
        exit(Format(TableNo));
    end;

    var
        DocumentTypeName: Text;
}
//JOA007-
