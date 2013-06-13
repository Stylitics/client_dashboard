class @WeatherChart
  constructor: (type) ->
    chart = @
    @JSON = null
    @ticks = []
    @last_step = 0
    @readJSON(chart)
  readJSON: (chart) ->
    d3.json $("#weather-chart").data('json'), (data) ->
      if data.data != "empty"
        chart.JSON = data
        $.each chart.JSON[0], (k, v) ->
          chart.ticks.push v[0]["sunny"]
          chart.ticks.push v[1]["overcast"]
          chart.ticks.push v[2]["rainy"]
          chart.ticks.push v[3]["snow"]
        chart.ticks.sort (a, b) ->
          a - b
        chart.last_step = chart.ticks[chart.ticks.length - 1]
        chart.drawChart(chart)
        chart.drawLegend(chart)
  drawChart: (chart) ->
    r_m = 255
    g_m = 255
    b_m = 255
    r_M = 28
    g_M = 131
    b_M = 146
    $.each chart.JSON[0], (k, v) ->
      # ugly but good
      c = v[0]["sunny"]
      p = c / chart.last_step
      $("." + k + ".sunny .weather-box").css backgroundColor: "rgb(" + parseInt(r_m - (r_m - r_M) * p) + ", " + parseInt(g_m - (g_m - g_M) * p) + ", " + parseInt(b_m - (b_m - b_M) * p) + ")"

      c = v[1]["overcast"]
      p = c / chart.last_step
      $("." + k + ".overcast .weather-box").css backgroundColor: "rgb(" + parseInt(r_m - (r_m - r_M) * p) + ", " + parseInt(g_m - (g_m - g_M) * p) + ", " + parseInt(b_m - (b_m - b_M) * p) + ")"

      c = v[2]["rainy"]
      p = c / chart.last_step
      $("." + k + ".rainy .weather-box").css backgroundColor: "rgb(" + parseInt(r_m - (r_m - r_M) * p) + ", " + parseInt(g_m - (g_m - g_M) * p) + ", " + parseInt(b_m - (b_m - b_M) * p) + ")"

      c = v[3]["snow"]
      p = c / chart.last_step
      $("." + k + ".snow .weather-box").css backgroundColor: "rgb(" + parseInt(r_m - (r_m - r_M) * p) + ", " + parseInt(g_m - (g_m - g_M) * p) + ", " + parseInt(b_m - (b_m - b_M) * p) + ")"
  drawLegend: (chart) ->
    $legend = $('#weather-legend-text')
    $legend.append "<span class=\"weather-text-number\">" + 0 + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + parseInt(chart.last_step / 4) + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + parseInt(chart.last_step / 2) + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + parseInt(parseInt(chart.last_step / 2) + parseInt(chart.last_step / 4)) + "</span>"
    $legend.append "<span class=\"weather-text-number\">" + chart.last_step + "</span>"