# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $('#trend-line-chart').length
    trend_line_chart = new VanilaTrendLineChart()

    $("label.radio").prepend("<span></span>")
    $("label.radio").each (i, label) ->
      input = $(label).find("input")
      input.insertBefore(label)
      $(label).attr("for", input.attr("id"))

    $("label.checkbox").prepend("<span></span>")
    $("label.checkbox").each (i, label) ->
      input = $(label).find("input")
      input.insertBefore(label)
      $(label).attr("for", input.attr("id"))

    $("#age-filter #min").html(10)
    $("#age-filter #max").html(100)
    $("#age-filter .slider").slider
      range: true
      min: 10
      max: 100
      values: [10, 100]
      slide: (event, ui) ->
        $("#age-filter #min").html(ui.values[0])
        $("#age-filter #max").html(ui.values[1])
        $("#chart_run_low_age_opt").val(ui.values[0])
        $("#chart_run_high_age_opt").val(ui.values[1])

    $("#price-filter #min").html(0)
    $("#price-filter #max").html(100000)
    $("#price-filter .slider").slider
      range: true
      min: 0
      max: 100000
      values: [0, 100000]
      slide: (event, ui) ->
        $("#price-filter #min").html(accounting.formatMoney(ui.values[0], "$", 0))
        $("#price-filter #max").html(accounting.formatMoney(ui.values[1], "$", 0))
        $("#chart_run_low_price_opt").val(ui.values[0])
        $("#chart_run_high_price_opt").val(ui.values[1])
    $("#price-filter #min").html(accounting.formatMoney(0, "$", 0))
    $("#price-filter #max").html(accounting.formatMoney(100000, "$", 0))

    $(".datepicker").datepicker
      dateFormat: "yy-mm-dd"
      showAnim: "fadeIn"

    $(".datepicker").datepicker
      dateFormat: "yy-mm-dd"
      showAnim: "fadeIn"

