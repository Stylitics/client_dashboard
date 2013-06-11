class @WeatherChart
  constructor: (type) ->
    chart = @
    @readJSON(chart)
  readJSON: (chart) ->
    d3.json $("#weather-chart").data('json'), (data) ->
      if data.data != "empty"
        chart.JSON = data
        chart.drawChart(chart)
        chart.drawLegend(chart)
  drawChart: (chart) ->
    console.log "draw"
  drawLegend: (chart) ->
    console.log "draw legend"