# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  data = [
    year: 2006
    books: 54
  ,
    year: 2007
    books: 43
  ,
    year: 2008
    books: 41
  ,
    year: 2009
    books: 44
  ,
    year: 2010
    books: 35
  ]
  barWidth = 40
  width = (barWidth + 10) * data.length
  height = 200
  x = d3.scale.linear().domain([0, data.length]).range([0, width])
  y = d3.scale.linear().domain([0, d3.max(data, (datum) ->
    datum.books
  )]).rangeRound([0, height])

  # add the canvas to the DOM
  d3Chart = d3.select("#dashboard-chart").append("svg:svg").attr("width", 590).attr("height", 500)
  d3Chart.selectAll("rect").data(data).enter().append("svg:rect").attr("x", (datum, index) ->
    x index
  ).attr("y", (datum) ->
    height - y(datum.books)
  ).attr("height", (datum) ->
    y datum.books
  ).attr("width", barWidth).attr "fill", "#2d578b"