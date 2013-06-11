class @Top10
  constructor: (type) ->
    chart = @
    @readJSON(chart)
  readJSON: (chart) ->
    $.getJSON $("#top-10").data('json'), (data) ->
      template = $("#top-item-template-color").html()
      html = Mustache.to_html(template, data[0])
      $('.color').html(html)
      $('.set-color').each ->
        cl = $(this).data("color").replace(/\s+/g, '-').toLowerCase()
        $(this).addClass(cl)
      template = $("#top-item-template-pattern").html()
      html = Mustache.to_html(template, data[1])
      $('.pattern').html(html)
      template = $("#top-item-template-style").html()
      html = Mustache.to_html(template, data[2])
      $('.style').html(html)