//JOA007+
pageextension 50164 "SCR Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    actions
    {
        addfirst(processing)
        {
            action("SCR Capture Signature")
            {
                ApplicationArea = All;
                Caption = 'Signature';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Signature;
                ToolTip = 'Capture or view the delivery and acceptance confirmation signature for this document.';

                trigger OnAction()
                var
                    SignatureCapturePage: Page "SCR Signature Capture";
                begin
                    SignatureCapturePage.SetDocument(Database::"Sales Invoice Header", Rec."No.");
                    SignatureCapturePage.RunModal();
                end;
            }
        }
    }
}
//JOA007-
