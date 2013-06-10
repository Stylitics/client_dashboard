# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $('#trend-line-chart').length
    trend_line_chart = new TrendLineChart()
  if $('#top-25-brands-and-retailers-chart').length
    top_25_brands_and_retailers = new Top25BrandsAndRetailers()

  $("#who").tabs()
  $(".who").click ->
    $('#chart_run_event_opt').val($(this).html())
    trend_line_chart.setCurrentType($(this).html())
    trend_line_chart.updateChart()
