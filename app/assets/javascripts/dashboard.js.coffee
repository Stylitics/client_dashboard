# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("label.radio").prepend("<span></span>")
  $("label.radio").each (i, label) ->
    input = $(label).find("input")
    input.insertBefore(label)
    $(label).attr("for", input.attr("id"))
    # input.remove()

  if $('#dashboard-chart').length
    trend_line_chart = new TrendLineChart('dashboard-chart')