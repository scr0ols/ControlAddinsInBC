//JOA007+
tableextension 50167 "SCR Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        //Calculated, not stored: no data is added to the standard table, so there is nothing
        //to migrate on upgrade. Being a FlowField is also what makes it filterable, which is
        //the whole point - a plain OnAfterGetRecord variable would display but not filter.
        field(50000; "SCR Signed"; Boolean)
        {
            Caption = 'Signed';
            Editable = false;
            FieldClass = FlowField;
            //112 is the object ID of "Sales Invoice Header". A CalcFormula only accepts
            //literals, so Database::"Sales Invoice Header" cannot be written here.
            CalcFormula = exist("SCR Document Signature"
                                where("Table No." = const(112),
                                      "Document No." = field("No.")));
        }
    }
}
//JOA007-
