//JOA001+ 
//This function is needs to be defined in the control add-in object so we can acess it.
function GeographicGraph(DataJson)
{

  google.charts.load('current', {
    'packages':['geochart'],
  });
  google.charts.setOnLoadCallback(drawRegionsMap);

  //Define chart settings
  function drawRegionsMap() {
    var data = google.visualization.arrayToDataTable(DataJson)
    let trackHeight = 30;
    var options = {
      displayMode: 'region', 
      datalessRegionColor: '#D0D3D4',
      backgroundColor: 'white',
      width: 797
    };
    //Add chart to controlAddIn
    var chart = new google.visualization.GeoChart(document.getElementById('controlAddIn')); //document.getElementById('controlAddIn) will return us the iframe that was reserverd for the control add-in in the web page.
    //Draw the chart on the control add-in
    chart.draw(data, options);

    var cli = chart.getChartLayoutInterface();
    var chartSize = cli.getBoundingBox('chart');
    alert(chartSize);
  }
}
//JOA001-