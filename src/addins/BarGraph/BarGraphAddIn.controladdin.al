controladdin "SCR Bar Graph Add-In"
{
    HorizontalShrink = true;
    HorizontalStretch = true;
    RequestedHeight = 500;

    StartupScript = 'src\shared\ControlReady_startup.js';
    Scripts = 'src\addins\BarGraph\BarChartsScript.js',
    'https://www.gstatic.com/charts/loader.js';

    event ControlReady();

    event OpenSalesOrders();
    event OpenSalesQuotes();
    event OpenSalesInvoices();
    event OpenPostedSalesInvoices();

    procedure barGraph(DataJson: JsonArray);
}

