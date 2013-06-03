class @TrendLineChart
  constructor: () ->
    screenWidth = $("#trend-line-chart").data("width")
    screenHeight = $("#trend-line-chart").data("height")
    svg = d3.select("#trend-line-chart").append("svg").attr("width", screenWidth).attr("height", screenHeight)

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#trend-line-chart").data("pattern-odd")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern-d').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#trend-line-chart").data("pattern-even")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)

    x = d3.time.scale().range([0, screenWidth])
    y = d3.scale.linear().range([screenHeight, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    xAxis.tickFormat (f) ->
      fD = getMonday(f)
      if fD.getDay() == 0
        fD = new Date(fD.getTime() + 1000 * 3600 * 24)
      format = d3.time.format("Week of %m/%d")
      format(fD)
    yAxis = d3.svg.axis().scale(y).orient("right")
    yAxis.tickFormat (f) ->
      if f == 0
        null
      else
        f

    parseDate = d3.time.format("%Y-%m-%d").parse

    line = d3.svg.line().interpolate("linear").x((d) ->
      x d[0]
    ).y((d) ->
      y d[1]
    )

    totalLength = 0
    pathB = null
    pathG = null
    addedPercentage = []
    wornPercentage = []
    d3.json $("#trend-line-chart").data('json'), (data) ->
      if data.data != "empty"
        xAxis.ticks(6)

        bg = svg.append("g").attr("class", "grid").attr("width", screenWidth).attr("height", screenHeight)

        data.forEach (d, i) ->
          if i % 2 == 0
            bgClass = "even"
          else
            bgClass = "odd"
          addedPercentage.push [parseDate(d.date), d.addedPercentage]
          wornPercentage.push [parseDate(d.date), d.wornPercentage]
          bg.append("rect").attr("width", screenWidth / (data.length - 1)).attr("height", screenHeight).attr("transform", "translate(" + ((screenWidth / (data.length - 1)) * i - 1) + ", 0)").attr("class", bgClass).attr()

        x.domain d3.extent(addedPercentage, (d) ->
          d[0]
        )

        # sort Y values
        allY = addedPercentage.concat(wornPercentage)
        allY.sort (a, b) ->
          a - b

        y.domain [0, d3.max(addedPercentage, (d) ->
          d[1]
        ) * 1.2]

        svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + (screenHeight - 1) + ")").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "3em").attr("dy", "1em")
        svg.append("g").attr("class", "y axis").call yAxis

        pathB = svg.append("g").attr("class", "trendline").append("path").datum(addedPercentage).attr("class", "line line-blue").attr("d", line)

        # pathG = svg.append("g").append("path").datum(wornPercentage).attr("class", "line line-green").attr("d", line)

        totalLength = pathB.node().getTotalLength()

        pathB.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

        d3.select(".x").attr("transform", "translate(0, 380)")
        d3.select(".y").attr("transform", "translate(0, -20)")
        d3.select(".grid").attr("transform", "translate(0, -20)")
        d3.select(".trendline").attr("transform", "translate(0, -20)")
        # tick line still present
        $(d3.select(".x.axis .tick.major")[0]).remove()

        # pathG.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

    # $('#selector1').click () ->
    #   if $(this).is(':checked') == true
    #     pathG.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
    #   else
    #     pathG.transition().duration(100).ease("linear").attr "stroke-dashoffset", totalLength

    # $('#selector2').click () ->
    #   if $(this).is(':checked') == true
    #     pathB.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
    #   else
    #     pathB.transition().duration(100).ease("linear").attr "stroke-dashoffset", totalLength
