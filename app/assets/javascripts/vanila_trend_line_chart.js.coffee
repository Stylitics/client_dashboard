class @VanilaTrendLineChart
  constructor: () ->
    screenWidth = 870
    screenHeight = 400
    svg = d3.select("#trend-line-chart").append("svg").attr("width", screenWidth).attr("height", screenHeight)

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#trend-line-chart").data("pattern-odd")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern-d').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#trend-line-chart").data("pattern-even")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)

    x = d3.time.scale().range([0, screenWidth])
    y = d3.scale.linear().range([screenHeight, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("right")

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
        xAxis.ticks(data.length)

        bg = svg.append("g").attr("width", screenWidth).attr("height", screenHeight)

        data.forEach (d, i) ->
          if i % 2 == 0
            bgClass = "even"
          else
            bgClass = "odd"
          addedPercentage.push [parseDate(d.date), d.addedPercentage]
          wornPercentage.push [parseDate(d.date), d.wornPercentage]
          bg.append("rect").attr("width", 920 / (data.length - 1)).attr("height", screenHeight).attr("transform", "translate(" + ((920 / (data.length - 1)) * i - 1) + ", 0)").attr("class", bgClass).attr()

        x.domain d3.extent(addedPercentage, (d) ->
          d[0]
        )

        # sort Y values
        allY = addedPercentage.concat(wornPercentage)
        allY.sort (a, b) ->
          a - b

        y.domain [0, 100]

        svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + (screenHeight - 1) + ")").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "-.8em").attr("dy", ".15em")#.attr("transform", (d) ->
          #   return "rotate(-65)"
          # )
        svg.append("g").attr("class", "y axis").attr("transform", "translate(0, -40").call yAxis

        pathB = svg.append("g").append("path").datum(addedPercentage).attr("class", "line line-blue").attr("d", line)

        pathG = svg.append("g").append("path").datum(wornPercentage).attr("class", "line line-green").attr("d", line)

        totalLength = pathB.node().getTotalLength()

        pathB.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

        pathG.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

    $('#selector1').click () ->
      if $(this).is(':checked') == true
        pathG.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
      else
        pathG.transition().duration(100).ease("linear").attr "stroke-dashoffset", totalLength

    $('#selector2').click () ->
      if $(this).is(':checked') == true
        pathB.attr("stroke-dasharray", totalLength + " " + totalLength).attr("stroke-dashoffset", totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
      else
        pathB.transition().duration(100).ease("linear").attr "stroke-dashoffset", totalLength
