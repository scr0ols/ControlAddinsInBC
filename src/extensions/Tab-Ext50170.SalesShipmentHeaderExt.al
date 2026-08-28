//JOA007+
tableextension 50170 "SCR Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        //Same shape as the field on "Sales Invoice Header": calculated, so nothing is stored
        //on the standard table, and filterable, which is what makes it useful on the list.
        field(50000; "SCR Signed"; Boolean)
        {
            Caption = 'Signed';
            Editable = false;
            FieldClass = FlowField;
            //110 is the object ID of "Sales Shipment Header". A CalcFormula only accepts
            //literals, so Database::"Sales Shipment Header" cannot be written here.
            CalcFormula = exist("SCR Document Signature"
                                where("Table No." = const(110),
                                      "Document No." = field("No.")));
        }
    }
}
//JOA007-
