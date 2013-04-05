$ ->
  $(".slider").slider
    range: true
    min: 0
    max: 500
    values: [75, 300]
    slide: (event, ui) ->
      console.log ui.values[0] + "<< >>" + ui.values[1]

  $(".datepicker").datepicker()
  $(".datepicker").datepicker "option", "showAnim", "fadeIn"