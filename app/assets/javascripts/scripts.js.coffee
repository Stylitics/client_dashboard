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
      $('#chart_run_who').val($(this).html())

  $(".chosen").chosen()

  $('#horiz_container_outer').horizontalScroll()

  # substraction tokens

  $("#my-saved-segments").click()

  $(document).on "keyup", "#chart_run_brand_search_chzn .default", (e) ->
    if e.keyCode == 189
      $("#chart_run_brand_search option").each () ->
        o = $(this)
        if o.html() != "" && o.html() != "All"
          o.value = "- " + o.html()
          o.html("- " + o.html())
      $('#chart_run_brand_search').trigger 'liszt:updated'

  $(document).on "change", "#chart_run_brand_search", () ->
    $("#chart_run_brand_search option").each () ->
      r = $(this)
      if r.html().substring(0, 2) == "- " && !r.is(":selected")
        r.value = r.html().substring(2)
        r.html(r.html().substring(2))
    $('#chart_run_brand_search').trigger 'liszt:updated'