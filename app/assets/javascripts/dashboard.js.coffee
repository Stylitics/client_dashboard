# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $('#dashboard-chart').length > -1
    screenWidth = 590
    screenHeight = 400
    svg = d3.select("#dashboard-chart").append("svg").attr("width", screenWidth).attr("height", screenHeight).append("g")

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern').attr('patternUnits', 'userSpaceOnUse').attr('width', '6').attr('height', '6').append('svg:image').attr('xlink:href', '/assets/pattern.png').attr('x', 0).attr('y', 0).attr('width', 6).attr('height', 6)

    svg.append('svg:defs').append('svg:pattern').attr('id', 'pattern-d').attr('patternUnits', 'userSpaceOnUse').attr('width', '6').attr('height', '6').append('svg:image').attr('xlink:href', '/assets/pattern-d.png').attr('x', 0).attr('y', 0).attr('width', 6).attr('height', 6)

    x = d3.time.scale().range([0, screenWidth])
    y = d3.scale.linear().range([screenHeight - 50, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")

    parseDate = d3.time.format("%Y-%m-%d").parse

    line = d3.svg.line().interpolate("basis").x((d) ->
      x d[0]
    ).y((d) ->
      y d[1]
    )

    adjustedSpecificItemsAdded = []
    adjustedSpecificWearings = []
    d3.json '/51648265fda8939a22000007.json', (data) ->
      xAxis.ticks(data.dates.length)

      bg = svg.append("g").attr("width", 590).attr("height", screenHeight);

      data.dates.forEach (d, i) ->
        if i % 2 == 0
          bgClass = "even"
        else
          bgClass = "odd"
        adjustedSpecificItemsAdded.push [parseDate(d), data.adjustedSpecificItemsAdded[i]]
        adjustedSpecificWearings.push [parseDate(d), data.adjustedSpecificWearings[i]]
        bg.append("rect").attr("width", 590 / data.dates.length).attr("height", screenHeight - 40).attr("transform", "translate(" + ((590 / data.dates.length) * i + i) + ", 0)").attr("class", bgClass).attr()

      x.domain d3.extent(adjustedSpecificItemsAdded, (d) ->
        d[0]
      )
      y.domain d3.extent(adjustedSpecificItemsAdded.concat(adjustedSpecificWearings), (d) ->
        d[1]
      )

      svg.append("g").attr("class", "x axis").attr("transform", "translate(0, " + (screenHeight - 40) + ")").call(xAxis).selectAll("text").style("text-anchor", "end").attr("dx", "-.8em").attr("dy", ".15em").attr("transform", (d) ->
          return "rotate(-65)"
        )
      svg.append("g").attr("class", "y axis").call yAxis

      window.pathB = svg.append("g").attr("transform", "translate(0, 10)").append("path").datum(adjustedSpecificItemsAdded).attr("class", "line line-blue").attr("d", line)

      window.pathG = svg.append("g").attr("transform", "translate(0, 10)").append("path").datum(adjustedSpecificWearings).attr("class", "line line-green").attr("d", line)

      window.totalLength = window.pathG.node().getTotalLength()

      window.pathB.attr("stroke-dasharray", window.totalLength + " " + window.totalLength).attr("stroke-dashoffset", window.totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

      window.pathG.attr("stroke-dasharray", window.totalLength + " " + window.totalLength).attr("stroke-dashoffset", window.totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

    $('#selector1').click () ->
      if $(this).is(':checked') == true
        window.pathG.attr("stroke-dasharray", window.totalLength + " " + window.totalLength).attr("stroke-dashoffset", window.totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
      else
        window.pathG.transition().duration(100).ease("linear").attr "stroke-dashoffset", window.totalLength

    $('#selector2').click () ->
      if $(this).is(':checked') == true
        window.pathB.attr("stroke-dasharray", window.totalLength + " " + window.totalLength).attr("stroke-dashoffset", window.totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
      else
        window.pathB.transition().duration(100).ease("linear").attr "stroke-dashoffset", window.totalLength
