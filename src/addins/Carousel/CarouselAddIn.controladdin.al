//JOA003+ 
controladdin "Carousel AddIn"
{
    HorizontalStretch = true;
    RequestedHeight = 200;

    //Scripts to include in the control add-in.Some external scripts are required to use Bootstrap
    Scripts = 'https://code.jquery.com/jquery-3.5.1.slim.min.js',
        'https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js',
        'https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js',
        'src\addins\Carousel\CarouselScript.js';

    //This script is invoked when the webpage (in this case page 22 "Customer List" ) with the control add-in is loaded.
    StartupScript = 'src\shared\ControlReady_startup.js';

    //Stylesheet for our control add-in, in this case we use an external file so we can use bootstrap styles
    StyleSheets = 'https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css';

    //Procedure that when called will run the function with same name defined in the scripts, for our example this function is declared in CarouselScript.js
    procedure SetCarouselData(Data: JsonObject);
    //In the ControlReady_startup.js we call this event to initialize the control add-in. This event will invoke the trigger ControlReady() in "Items by Countries" page.
    event ControlReady();
}
//JOA003-