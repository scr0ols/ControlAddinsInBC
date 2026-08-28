//JOA006+ 
tableextension 50155 "SCR Sales Receiv. Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "SCR Note Nos."; Code[20])
        {
            Caption = 'Note Nos.';
            TableRelation = "No. Series";
        }
    }
}
//JOA006-