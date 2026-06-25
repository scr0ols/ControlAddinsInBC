//JOA002+ 
//This function is needs to be defined in the control add-in object so we can acess it.
function PieChart(DataJson)
{
    console.log(DataJson);
    google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable(DataJson);
        //Define chart options
        var options = {
          title:'Sales Order Status Statistics',
          fontName: 'Segoe UI',
          width: 380,
          is3D: true,
          slices: {
            0: {color: '#dc3912'},
            1: {color: '#109618', offset: 0.12}
          },
          legend: {
            textStyle: {
              fontName: 'Segoe UI',
              color: '#6f6f6f'
            }
          },
          titleTextStyle: {
            fontName: 'Segoe UI',
            color: '#6f6f6f',
            bold: true,
          }
        };
        //Add chart to controlAddIn
        var chart = new google.visualization.PieChart(document.getElementById('controlAddIn'));

        //Event that will trigger if the user clicks on the chart
        function selectHandler() {
            debugger;
            var selectedItem = chart.getSelection()[0];
            if (selectedItem) {
                var value = data.getValue(selectedItem.row, 0);
                if (value == 'Released') {
                    //If the user click on the slice that represents the Released sales order we will invoke the FilterByReleasedStatus on "Pie Chart" page
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FilterByReleasedStatus', []);
                } else {
                    //If the user click on the slice that represents the Open sales order we will invoke the FilterByOpenStatus on "Pie Chart" page
                    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('FilterByOpenStatus', []);
                }
            }
        }
        //Event listener
        google.visualization.events.addListener(chart, 'select', selectHandler);
        //Draw the chart on the control add-in
        chart.draw(data, options);
    }
}
//JOA002-