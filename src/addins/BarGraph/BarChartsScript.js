function barGraph(DataJson) {
  google.charts.load('current', {'packages':['bar']});
  google.charts.setOnLoadCallback(drawStuff);

  function drawStuff() {
    var data = new google.visualization.arrayToDataTable(DataJson);

    var options = {
      title: 'Sales Moves',
      width: 900,
      legend: { position: 'none' },
      chart: { title: 'Sales moves',
               subtitle: 'Quantity by sales type' },
      bars: 'horizontal', // Required for Material Bar Charts.
      axes: {
        x: {
          0: { side: 'top', label: 'Quantity'} // Top x-axis.
        }
      },
      bar: { groupWidth: "90%" }
    };
    var chart = new google.charts.Bar(document.getElementById('controlAddIn'));

    function selectHandler() {
      var selectedBar = chart.getSelection()[0];
      if (selectedBar) {
        var value = data.getValue(selectedBar.row, 0);
        if (value == 'Quotes') {
          Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OpenSalesQuotes',[]);
        } else if (value == 'Orders') {
          Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OpenSalesOrders',[]);
        } else if (value == 'Invoices') {
          Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OpenSalesInvoices',[]);
        } else {
          Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OpenPostedSalesInvoices', []);
        }
      }
    }

    google.visualization.events.addListener(chart, 'select', selectHandler);
    chart.draw(data, options);
  };
}



