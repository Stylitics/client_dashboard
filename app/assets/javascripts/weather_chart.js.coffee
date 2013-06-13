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
    ticks.sort (a, b) ->
      a - b
    $legend = $('#weather-legend-text')
    last_step = ticks[ticks.length - 1]
    $legend.append "<span class=\"weather-text-number\">" + 0 + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + parseInt(last_step / 4) + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + parseInt(last_step / 2) + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + parseInt(parseInt(last_step / 2) + parseInt(last_step / 4)) + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + last_step + "</span>"