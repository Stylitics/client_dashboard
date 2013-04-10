# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if $('#dashboard-chart').length > -1
    screenWidth = 590
    screenHeight = 400
    svg = d3.select("#dashboard-chart").append("svg").attr("width", screenWidth).attr("height", screenHeight)

    x = d3.time.scale().range([0, screenWidth])
    y = d3.scale.linear().range([screenHeight, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")

    parseDate = d3.time.format("%Y-%m-%d").parse

    line = d3.svg.line().x((d) ->
      x d[0]
    ).y((d) ->
      y d[1]
    )

    adjustedSpecificItemsAdded = []
    adjustedSpecificWearings = []
    d3.json '/51648265fda8939a22000007.json', (data) ->
      data.dates.forEach (d, i) ->
        adjustedSpecificItemsAdded.push [parseDate(d), data.adjustedSpecificItemsAdded[i]]
        adjustedSpecificWearings.push [parseDate(d), data.adjustedSpecificWearings[i]]

      x.domain d3.extent(adjustedSpecificItemsAdded, (d) ->
        d[0]
      )
      y.domain d3.extent(adjustedSpecificItemsAdded, (d) ->
        d[1]
      )

      svg.append("g").attr("class", "x axis").attr("transform", "translate(0, 340)").call xAxis
      svg.append("g").attr("class", "y axis").attr("transform", "translate(50, 0)").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 10).attr("dy", ".71em").style("text-anchor", "end").text "Y legend"
      window.path = svg.append("path").datum(adjustedSpecificItemsAdded).attr("class", "line").attr("d", line)
      window.totalLength = window.path.node().getTotalLength()
      window.path.attr("stroke-dasharray", window.totalLength + " " + window.totalLength).attr("stroke-dashoffset", window.totalLength).transition().duration(1000).ease("linear").attr "stroke-dashoffset", 0

    $('#selector1').click () ->
      if $(this).is(':checked') == true
        window.path.attr("stroke-dasharray", window.totalLength + " " + window.totalLength).attr("stroke-dashoffset", window.totalLength).transition().duration(500).ease("linear").attr "stroke-dashoffset", 0
      else
        window.path.transition().duration(100).ease("linear").attr "stroke-dashoffset", window.totalLength