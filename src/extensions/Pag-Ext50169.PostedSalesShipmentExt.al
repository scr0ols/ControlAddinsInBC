//JOA007+
pageextension 50169 "SCR Posted Sales Shipment Ext" extends "Posted Sales Shipment"
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
                    SignatureCapturePage.SetDocument(Database::"Sales Shipment Header", Rec."No.");
                    SignatureCapturePage.RunModal();
                end;
            }
        }
    }
}
//JOA007-
