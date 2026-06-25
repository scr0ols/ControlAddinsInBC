//JOA006+ 
tableextension 60000 "Sales Receivables Setup Ext" extends "Sales & Receivables Setup"
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