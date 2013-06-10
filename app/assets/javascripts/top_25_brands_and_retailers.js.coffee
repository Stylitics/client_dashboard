class @Top25BrandsAndRetailers
  constructor: (type) ->
    chart = @
    @readJSON(chart)
  readJSON: (chart) ->
    $.getJSON $("#top-25-brands-and-retailers-chart").data('json'), (data) ->
      template = $("#top-item-template-own").html()
      html = Mustache.to_html(template, data[0])
      $('.own_25').html(html)
      template = $("#top-item-template-shop").html()
      html = Mustache.to_html(template, data[1])
      $('.shop_at_25').html(html)