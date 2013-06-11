class @WeatherChart
  constructor: (type) ->
    chart = @
    @readJSON(chart)
  readJSON: (chart) ->
    console.log "JSON"