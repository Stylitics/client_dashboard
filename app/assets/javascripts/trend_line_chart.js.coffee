maxY = (values, q) ->
  # sort Y values and return the maximum value
  allY = []
  $.each(values, (k, v) ->
    allY.push(v[1])
  )
  allY.sort (a, b) ->
    a - b
  allY[allY.length - 1] * q

class @TrendLineChart
  constructor: () ->
    chart = @
    @screenWidth = $("#trend-line-chart").data("width")
    @screenHeight = $("#trend-line-chart").data("height")
    @zoomWidth  = $("#trend-line-chart-zoom").data("width")
    @zoomHeight = $("#trend-line-chart-zoom").data("height")
    @totalLength = 0
    @pathAdded = null
    @pathAddedZoom = null
    @pathWorn = null
    @pathWornZoom = null
    @pathBought = null
    @pathBoughtZoom = null
    @addedPercentage = []
    @wornPercentage = []
    @boughtPercentage = []
    @JSON = null
    @svg = null
    @zoom = null
    @circle = null
    @brush = null
    @readJSON(chart)
  readJSON: (chart) ->
    d3.json $("#trend-line-chart").data('json'), (data) ->
      if data.data != "empty"
        chart.JSON = data
        chart.drawChart(chart)
  drawChart: (chart) ->
    chart.svg = d3.select("#trend-line-chart").append("svg").attr("width", chart.screenWidth).attr("height", chart.screenHeight)
    chart.svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#trend-line-chart").data("pattern-odd")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)
    chart.svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern-d').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#trend-line-chart").data("pattern-even")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)
    bg = chart.svg.append("g").attr("class", "grid").attr("width", chart.screenWidth).attr("height", chart.screenHeight)
    parseDate = d3.time.format("%Y-%m-%d").parse
    chart.JSON.forEach (d, i) ->
      if i % 2 == 0
        bgClass = "even"
      else
        bgClass = "odd"
      chart.addedPercentage.push [parseDate(d.date), d.addedPercentage]
      chart.wornPercentage.push [parseDate(d.date), d.wornPercentage]
      chart.boughtPercentage.push [parseDate(d.date), d.boughtPercentage]
      bg.append("rect").attr("width", chart.screenWidth / (chart.JSON.length - 1)).attr("height", chart.screenHeight).attr("transform", "translate(" + ((chart.screenWidth / (chart.JSON.length - 1)) * i - 1) + ", 0)").attr("class", bgClass).attr()
    chart.drawZoomUI(chart)
    chart.render(chart, chart.addedPercentage)
    chart.renderZoomUI(chart, chart.addedPercentage)
    chart.centerChart(chart)
  render: (chart, values) ->
    x = d3.time.scale().range([0, chart.screenWidth])
    y = d3.scale.linear().range([chart.screenHeight, 0])
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
    line = d3.svg.line().interpolate("linear").x((d) ->
      x d[0]
    ).y((d) ->
      y d[1]
    )
    xAxis.ticks(6)
    x.domain d3.extent(values, (d) ->
      d[0]
    )
    y.domain [0, maxY(values, 1.1)]
    chart.svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + (chart.screenHeight - 1) + ")").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "3em").attr("dy", "1em")
    chart.svg.append("g").attr("class", "y axis").call yAxis
    chart.pathAdded = chart.svg.append("g").attr("class", "trendline").append("path").datum(values).attr("class", "line line-blue").attr("d", line)
    chart.totalLength = chart.pathAdded.node().getTotalLength()
    chart.pathAdded.attr("stroke-dasharray", chart.totalLength + " " + chart.totalLength).attr("stroke-dashoffset", chart.totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0
  drawZoomUI: (chart) ->
    chart.svgZoom = d3.select("#trend-line-chart-zoom").append("svg").attr("width", chart.zoomWidth).attr("height", chart.zoomHeight)
  renderZoomUI: (chart, values) ->
    x = d3.time.scale().range([0, chart.zoomWidth])
    y = d3.scale.linear().range([chart.zoomHeight, 0])
    xAxis = d3.svg.axis().scale(x).orient("bottom")
    xAxis.tickFormat (f) ->
      format = d3.time.format("%B")
      format(f)
    yAxis = d3.svg.axis().scale(y).orient("left")
    yAxis.tickFormat (f) ->
      null
    line = d3.svg.line().interpolate("linear").x((d) ->
      x d[0]
    ).y((d) ->
      y d[1]
    )
    xAxis.ticks(6)
    x.domain d3.extent(values, (d) ->
      d[0]
    )
    y.domain [0, maxY(values, 1.5)]
    chart.svgZoom.append("g").attr("transform", "translate(0, " + (chart.zoomHeight - 20) + ")").attr("class", "xZ axis").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "3em").attr("dy", "1em")
    chart.svgZoom.append("g").attr("transform", "translate(-1, 0)").attr("class", "yZ axis").call(yAxis)
    chart.pathAddedZoom = chart.svgZoom.append("g").attr("class", "trendlineZ zoomUI").append("path").datum(values).attr("class", "line line-blue").attr("d", line)
    chart.totalLength = chart.pathAddedZoom.node().getTotalLength()
    chart.pathAddedZoom.attr("stroke-dasharray", chart.totalLength + " " + chart.totalLength).attr("stroke-dashoffset", chart.totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

    circle = chart.svgZoom.append("g").selectAll("circle").data(x).enter().append("circle").attr("transform", (d) ->
      "translate(" + x(d) + "," + y() + ")"
    ).attr("r", 3.5)

    brush = d3.svg.brush().x(x).extent([chart.addedPercentage[0][0],chart.addedPercentage[chart.addedPercentage.length-1][0]]).on("brushstart", ->
      chart.svgZoom.classed("selecting", true)
    ).on("brush", ->
      s = brush.extent()
      selectedInterval = new Array()
      dateStart = new Date(s[0])
      dateEnd = new Date(s[1])
      console.log "======BEGINING======"
      for i of chart.addedPercentage
        currentDate = new Date(chart.addedPercentage[i][0])
        if (currentDate.getTime() - dateStart.getTime())>=0 and (currentDate.getTime() - dateEnd.getTime())<=0
          selectedInterval.push chart.addedPercentage[i]
      chart.render(chart, selectedInterval)
      circle.classed "selected", (d) ->
       s[0] <= d and d <= s[1]
    ).on("brushend", ->
      chart.svgZoom.classed("selecting", !d3.event.target.empty())
    )
    
    arc = d3.svg.arc().outerRadius((chart.zoomHeight-15) / 2).startAngle(0).endAngle((d, i) ->
      (if i then -Math.PI else Math.PI)
    )

    brushg = chart.svgZoom.append("g").attr("class", "brush").call(brush)
    brushg.selectAll(".resize").append("path").attr("transform", "translate(0," + (chart.zoomHeight-15) / 2 + ")").attr "d"
    brushg.selectAll("rect").attr "height", (chart.zoomHeight-15)


  centerChart: (chart) ->
    d3.select(".x").attr("transform", "translate(0, " + (chart.screenHeight - 20) + ")")
    d3.select(".y").attr("transform", "translate(0, -20)")
    d3.select(".grid").attr("transform", "translate(0, -20)")
    d3.select(".trendline").attr("transform", "translate(0, -20)")
    d3.select(".xZ").attr("transform", "translate(0, " + (chart.zoomHeight - 20) + ")")
    d3.select(".yZ").attr("transform", "translate(-1, -20)")
    d3.select(".trendlineZ").attr("transform", "translate(0, -20)")
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

