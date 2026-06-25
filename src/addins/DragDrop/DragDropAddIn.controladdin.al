//JOA004+ 
controladdin "Drag and Drop AddIn"
{
    //This is the height reserved in the web page for the control add-in.
    RequestedHeight = 280;

    //We dont define a width but we define the minimum and the maximum width allowed by the control add-in
    MinimumWidth = 100;
    MaximumWidth = 400;

    VerticalShrink = true;
    VerticalStretch = true;
    HorizontalShrink = true;
    HorizontalStretch = true;

    //This script is invoked when the webpage (in this case page 31 "Item List" ) with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';

    //Script to include in the control add-in.  
    Scripts = 'src\addins\DragDrop\DragDropScript.js', 'https://code.jquery.com/jquery-3.6.0.min.js';

    //Style to include
    StyleSheets = 'src\addins\DragDrop\DragDrop.stylesheet.css';

    //In the ControlReady_startup.js we call this event to initialize the control add-in. This event will invoke the trigger ControlReady() in "Items by Countries" page.
    event ControlReady();

    //Event responsible to trigger GetFileContent(curr_file: Text) in "Drag and Drop" page and transfer the data to create new items
    event GetFileContent(curr_file: Text);
    //Procedure that when called will run the function with same name defined in the scripts, for our example this function is declared in DragDropScript.js
    procedure embedDragDropBox();
}
//JOA004-