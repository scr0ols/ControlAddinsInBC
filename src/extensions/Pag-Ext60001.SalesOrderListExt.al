pageextension 60001 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        //JOA002+ 
        //Let's add our page part responsible for the control add-in
        addfirst(FactBoxes)
        {
            part(PieChart; "Pie Chart")
            {
                ApplicationArea = All;
            }
        }
        //JOA002-
    }
}
