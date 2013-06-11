class @BrandShareChart
  constructor: (type) ->
    chart = @
    @screenWidth = $("#brand-share-chart").data("width")
    @screenHeight = $("#brand-share-chart").data("height")
    @zoomWidth  = $("#brand-share-chart-zoom").data("width")
    @zoomHeight = $("#brand-share-chart-zoom").data("height")
    @totalLength = 0
    @pathAdded = null
    @pathAddedZoom = null
    @pathWorn = null
    @pathWornZoom = null
    @pathBought = null
    @pathBoughtZoom = null
    @dataPercentage = []
    @percentage=[]
    @currentType = type
    @JSON = null
    @svg = null
    @zoom = null
    @circle = null
    @brush = null
    @readJSON(chart)

  updateChart: () ->
      this.render(this, this.percentage, true)
      this.centerChart(this)

  readJSON: (chart) ->
    d3.json $("#brand-share-chart").data('json'), (data) ->
      if data.data != "empty"
        chart.JSON = data
        chart.drawChart(chart)
  drawChart: (chart) ->
    chart.svg = d3.select("#brand-share-chart").append("svg").attr("width", chart.screenWidth).attr("height", chart.screenHeight)
    chart.svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#brand-share-chart").data("pattern-odd")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)
    chart.svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern-d').attr('patternUnits', 'userSpaceOnUse').attr('width', '10').attr('height', '10').append('svg:image').attr('xlink:href', $("#brand-share-chart").data("pattern-even")).attr('x', 0).attr('y', 0).attr('width', 10).attr('height', 10)
    bg = chart.svg.append("g").attr("class", "grid").attr("width", chart.screenWidth).attr("height", chart.screenHeight)
    parseDate = d3.time.format("%Y-%m-%d").parse
    chart.JSON.forEach (d, i) ->
      if i % 2 == 0
        bgClass = "even"
      else
        bgClass = "odd"
      chart.dataPercentage.push [parseDate(d.date), d.percentage]
      bg.append("rect").attr("width", chart.screenWidth / (chart.JSON.length - 1)).attr("height", chart.screenHeight).attr("transform", "translate(" + ((chart.screenWidth / (chart.JSON.length - 1)) * i - 1) + ", 0)").attr("class", bgClass).attr()
    chart.drawZoomUI(chart)
    chart.render(chart, chart.dataPercentage, false)
    chart.renderZoomUI(chart, chart.dataPercentage)
    chart.centerChart(chart)
  remove: (chart, selector) ->
    chart.svg.selectAll(selector).data([]).exit().remove()
  render: (chart, values, update) ->
    if update is true
      chart.remove(chart,".trendline")
      chart.remove(chart,".xaxis")
      chart.remove(chart,".yaxis")
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
        parseInt(f, 10) + "%"
    line = d3.svg.line().interpolate("linear").x((d) ->
      x d[0]
    ).y((d) ->
      y d[1]
    )
    xAxis.ticks(6)
    x.domain d3.extent(values, (d) ->
      d[0]
    )
    y.domain [0, d3.max(values, (d) ->
      d[1]
    ) * 1.2]
    chart.svg.append("g").attr("class", "x axis xaxis").attr("transform", "translate(0, " + (chart.screenHeight - 1) + ")").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "3em").attr("dy", "1em")
    chart.svg.append("g").attr("class", "y axis yaxis").call yAxis

    chart.pathAdded = chart.svg.append("g").attr("class", "trendline").append("path").datum(values).attr("class", "line line-blue").attr("d", line)
    chart.totalLength = chart.pathAdded.node().getTotalLength()
    chart.pathAdded.attr("stroke-dasharray", chart.totalLength + " " + chart.totalLength).attr("stroke-dashoffset", chart.totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0
  drawZoomUI: (chart) ->
    chart.svgZoom = d3.select("#brand-share-chart-zoom").append("svg").attr("width", chart.zoomWidth).attr("height", chart.zoomHeight)
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

    brush = d3.svg.brush().x(x).extent([chart.dataPercentage[0][0],chart.dataPercentage[chart.dataPercentage.length-1][0]]).on("brushstart", ->
      chart.svgZoom.classed("selecting", true)
    ).on("brush", ->
      s = brush.extent()
      selectedInterval = new Array()
      dateStart = new Date(s[0])
      dateEnd = new Date(s[1])
      for i of chart.dataPercentage
        currentDate = new Date(chart.dataPercentage[i][0])
        if (currentDate.getTime() - dateStart.getTime())>=0 and (currentDate.getTime() - dateEnd.getTime())<=0
          selectedInterval.push chart.dataPercentage[i]
      chart.render(chart, selectedInterval, true)
      chart.centerChart(chart)
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
