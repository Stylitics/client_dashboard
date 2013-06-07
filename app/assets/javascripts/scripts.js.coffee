$ ->
  $("#open-filters").click (e) ->
    e.preventDefault()
    if $(".left").is(":visible")
      $(".left .sidebar").hide "slide",
      direction: "left"
      , 500, ->
        $(".left").hide()
      $("#open-filter-icon").removeClass('icon-chevron-left')
      $("#open-filter-icon").addClass('icon-chevron-right')
    else
      $(".left").show()
      $(".left .sidebar").show "slide",
        direction: "left"
        , 500
      $("#open-filter-icon").removeClass('icon-chevron-right')
      $("#open-filter-icon").addClass('icon-chevron-left')


  $("#my-saved-segments").click (e) ->
    e.preventDefault()
    if $("#filters-container").is(":visible")
      $("#filters-container").hide "slide",
      direction: "top"
      , 500, ->
        $(".left").hide()
      $(this).find('#icon').removeClass('icon-chevron-up')
      $(this).find('#icon').addClass('icon-chevron-down')
    else
      $("#filters-container").show "slide",
        direction: "top"
        , 500
      $(this).find('#icon').removeClass('icon-chevron-down')
      $(this).find('#icon').addClass('icon-chevron-up')

  $("#maps").tabs()
  $("#who").tabs()

  $(".who").click ->
      $('#chart_run_event_opt').val($(this).html())

  $(".chosen").chosen()

  $('#horiz_container_outer').horizontalScroll()

  $("#show-me").click () ->
    $("#show-me").val("Loading...")

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

  $("#age-filter #min").html($("#chart_run_low_age_opt").val())
  $("#age-filter #max").html($("#chart_run_high_age_opt").val())
  $("#age-filter .slider").slider
    range: true
    min: 10
    max: 100
    values: [$("#chart_run_low_age_opt").val(), $("#chart_run_high_age_opt").val()]
    slide: (event, ui) ->
      $("#age-filter #min").html(ui.values[0])
      $("#age-filter #max").html(ui.values[1])
      $("#chart_run_low_age_opt").val(ui.values[0])
      $("#chart_run_high_age_opt").val(ui.values[1])

  $("#price-filter #min").html($("#chart_run_low_price_opt").val())
  $("#price-filter #max").html($("#chart_run_high_age_opt").val())
  $("#price-filter .slider").slider
    range: true
    min: 0
    max: 100000
    values: [$("#chart_run_low_price_opt").val(), $("#chart_run_high_price_opt").val()]
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

