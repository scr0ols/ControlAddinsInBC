//JOA006+ 
pageextension 50154 "SCR Sales Receiv. Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("SCR Note Nos."; Rec."SCR Note Nos.")
            {
                Caption = 'Note Nos.';
                ApplicationArea = All;
            }
        }
    }
}
//JOA006-