//JOA007+
pageextension 50171 "SCR Posted Sales Shpt List Ext" extends "Posted Sales Shipments"
{
    layout
    {
        //Anchored on the "No." control rather than on the repeater, whose name is an
        //implementation detail of the base page.
        addafter("No.")
        {
            field("SCR Signed"; Rec."SCR Signed")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies whether a signature has been captured for this document. Filter on this field to find the documents still waiting to be signed.';
            }
        }
    }
}
//JOA007-
