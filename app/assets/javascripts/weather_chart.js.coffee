class @WeatherChart
  constructor: (type) ->
    chart = @
    @JSON = null
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
    ticks = []
    $.each chart.JSON[0], (k, v) ->
      ticks.push v[0]["sunny"]
      ticks.push v[1]["overcast"]
      ticks.push v[2]["rainy"]
      ticks.push v[3]["snow"]
    console.log ticks
    ticks.sort (a, b) ->
      a - b
    console.log ticks[ticks.length - 1]