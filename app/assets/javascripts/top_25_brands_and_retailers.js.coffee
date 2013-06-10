class @Top25BrandsAndRetailers
  constructor: (type) ->
    chart = @
    @readJSON(chart)
  readJSON: (chart) ->
    $.getJSON 'json/data2.json', (data) ->
        template = $("#top-item-template").html()
        html = Mustache.to_html(template, data["own"])
        $('.own_25').html(html)