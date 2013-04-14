class @TrendLineChart
  constructor: (dashboard_wrapper) ->
    screenWidth = $('#dashboard-chart').data('width')
    screenHeight = $('#dashboard-chart').data('height')
    svg = d3.select("#dashboard-chart").append("svg").attr("width", screenWidth).attr("height", screenHeight).append("g")

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern').attr('patternUnits', 'userSpaceOnUse').attr('width', '6').attr('height', '6').append('svg:image').attr('xlink:href', '/assets/pattern.png').attr('x', 0).attr('y', 0).attr('width', 6).attr('height', 6)

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern-d').attr('patternUnits', 'userSpaceOnUse').attr('width', '6').attr('height', '6').append('svg:image').attr('xlink:href', '/assets/pattern-d.png').attr('x', 0).attr('y', 0).attr('width', 6).attr('height', 6)

    parseDate = d3.time.format("%Y-%m-%d").parse

    d3.json $("#dashboard-chart").data('json'), (data) ->

      #     adjusted_specific_items_added = []
#     adjusted_specific_wearings = []

#     bg = @svg.append("g").attr("width", @screenWidth).attr("height", @screenHeight)

#     @data.dates.forEach (d, i) ->
#       if i % 2 == 0
#         bgClass = "even"
#       else
#         bgClass = "odd"

#

#       adjusted_specific_items_added.push [parseDate(d), data.adjustedSpecificItemsAdded[i]]

#       adjusted_specific_wearings.push [parseDate(d), data.adjustedSpecificWearings[i]]

#       bg.append("rect").attr("width", 590 / data.dates.length).attr("height", screenHeight - 40).attr("transform", "translate(" + ((590 / data.dates.length) * i + i) + ", 0)").attr("class", bgClass).attr()

#     @adjusted_specific_items_added = adjusted_specific_items_added
#     @adjusted_specific_wearings = adjusted_specific_wearings

#   setup_axis: (data_set) ->
#     @svg.append("g").attr("class", "x axis")
#     x = d3.time.scale().range([0, @screenWidth])
#     y = d3.scale.linear().range([@screenHeight - 50, 0])

#     xAxis = d3.svg.axis().scale(x).orient("bottom")
#     yAxis = d3.svg.axis().scale(y).orient("left")

#     line = d3.svg.line().interpolate("basis").x((d) ->
#       x d[0]
#     ).y((d) ->
#       y d[1]
#     )

#     xAxis.ticks(@data.dates.length)

#     x.domain d3.extent(@adjusted_specific_items_added, (d) ->
#       d[0]
#     )

#     if data_set == ['adjusted_specific_items_added', 'adjusted_specific_wearings'] or data_set == undefined
#       y.domain d3.extent(@adjusted_specific_items_added.concat(@adjusted_specific_wearings), (d) ->
#         d[1]
#       )
#     else
#       y.domain d3.extent(@[data_set], (d) ->
#         d[1]
#       )

#     @svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + (@screenHeight - 40) + ")").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "-.8em").attr("dy", ".15em").attr("transform", (d) ->
#         return "rotate(-65)"
#       )
#     @svg.append("g").attr("class", "y axis").call(yAxis).selectAll("text").style("text-anchor", "end").attr("dx", "3.5em")

#     @pathB = @svg.append("g").attr("transform", "translate(0, 10)").append("path").datum(@adjusted_specific_items_added).attr("class", "line line-blue").attr("d", line)

#     @pathG = @svg.append("g").attr("transform", "translate(0, 10)").append("path").datum(@adjusted_specific_wearings).attr("class", "line line-green").attr("d", line)

#     @totalLength = @pathG.node().getTotalLength()

#     @pathB.attr("stroke-dasharray", @totalLength + " " + @totalLength).attr("stroke-dashoffset", @totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

#     @pathG.attr("stroke-dasharray", @totalLength + " " + @totalLength).attr("stroke-dashoffset", @totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

    #   $('#selector1').click () ->
    #     if $(this).is(':checked') == true
    #       trend_line_chart.pathG.attr("stroke-dasharray", trend_line_chart.totalLength + " " + trend_line_chart.totalLength).attr("stroke-dashoffset", trend_line_chart.totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
    #     else
    #       trend_line_chart.pathG.transition().duration(100).ease("linear").attr "stroke-dashoffset", trend_line_chart.totalLength

    #     trend_line_chart.setup_axis('adjusted_specific_items_added')

    #   $('#selector2').click () ->
    #     if $(this).is(':checked') == true
    #       trend_line_chart.pathB.attr("stroke-dasharray", trend_line_chart.totalLength + " " + trend_line_chart.totalLength).attr("stroke-dashoffset", trend_line_chart.totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
    #     else
    #       trend_line_chart.pathB.transition().duration(100).ease("linear").attr "stroke-dashoffset", trend_line_chart.totalLength

    #     trend_line_chart.setup_axis('adjusted_specific_wearings')
