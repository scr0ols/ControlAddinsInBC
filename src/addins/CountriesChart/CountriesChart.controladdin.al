//JOA001+ 
controladdin "Countries Chart AddIn"
{
    //This script is invoked when the webpage (in this case page 60000 "Items by Countries" ) with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';
    //Script to include in the control add-in.  
    Scripts = 'src\addins\CountriesChart\CountriesChartScript.js', 'https://www.gstatic.com/charts/loader.js';

    HorizontalStretch = true;
    VerticalStretch = true;
    //This is the area reserved in the web page for the control add-in.
    RequestedHeight = 490;
    RequestedWidth = 797;

    //In the ControlReady_startup.js we call this event to initialize the control add-in. This event will invoke the trigger ControlReady() in "Items by Countries" page.
    event ControlReady()

    //Procedure that when called will run the function with same name defined in the scripts, for our example this function is declared in CountriesChartScript.js
    procedure GeographicGraph(DataJson: JsonArray)
}
//JOA001-