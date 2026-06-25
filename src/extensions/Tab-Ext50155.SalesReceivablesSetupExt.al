//JOA006+ 
tableextension 50155 "SCR Sales Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Note Nos."; Code[20])
        {
            Caption = 'Note Nos.';
            TableRelation = "No. Series";
        }
    }
}
//JOA006-