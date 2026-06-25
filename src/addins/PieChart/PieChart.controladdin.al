//JOA002+ 
controladdin "SCR Pie Charts AddIn"
{
    //This script is invoked when the webpage (in this case page 9305 "Sales Order List" ) with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';
    //Script to include in the control add-in.  
    Scripts = 'src\addins\PieChart\PieCharts.js', 'https://www.gstatic.com/charts/loader.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    //This is the area reserved in the web page for the control add-in.
    RequestedHeight = 200;
    RequestedWidth = 320;

    //In the ControlReady_startup.js we call this event to initialize the control add-in. This event will invoke the trigger ControlReady() in "Sales Order List" page
    event ControlReady();
    //This event will invoke FilterByReleasedStatus in "Sales Order List" responsible to filter the sales order by status "Released"
    event FilterByReleasedStatus()

    //This event will invoke FilterByReleasedStatus in "Sales Order List" responsible to filter the sales order by status "Open"
    event FilterByOpenStatus()
    //Procedure that when called will run the function with same name defined in the scripts, for our example this function is declared in PieCharts.js
    procedure PieChart(DataJson: JsonArray);
}
//JOA002-