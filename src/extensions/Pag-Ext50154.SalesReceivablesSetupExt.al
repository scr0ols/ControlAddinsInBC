//JOA006+ 
pageextension 50154 "SCR Sales Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("Note Nos."; Rec."Note Nos.")
            {
                Caption = 'Note Nos.';
                ApplicationArea = All;
            }
        }
    }
}
//JOA006-