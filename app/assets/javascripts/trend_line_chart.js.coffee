class @TrendLineChart
  constructor: () ->
    trend_chart = dc.compositeChart("#trend-line-chart");
    weekly_chart = dc.compositeChart("#weekly-chart");
    top_asid = dc.dataTable("#top-asid")
    top_asw = dc.dataTable("#top-asw")

    dateFormat = d3.time.format("%Y-%m-%d")
    parseDate = dateFormat.parse
    numberFormat = d3.format(".6f")

    d3.json $("#trend-line-chart").data('json'), (json_data) ->
      # console.log(json_data)
      if json_data.data == "empty"
        $("#trend-chart-toggles").addClass("hide")
        $("#trend-chart-placeholder").removeClass("hide")
      else
        $("#trend-chart-toggles").removeClass("hide")
        $("#trend-chart-placeholder").addClass("hide")
        json_data.forEach (e) ->
          e.dd = parseDate(e.date)
          e.week = d3.time.week(e.dd)
          e.asid = parseFloat(e.adjustedSpecificItemsAdded)
          e.asw = parseFloat(e.adjustedSpecificWearings)

        data = crossfilter(json_data)

        weeks = data.dimension((d) ->
          d.week
        )

        asid_weeks_group = weeks.group().reduceSum((w) ->
          w.asid
        )

        asw_weeks_group = weeks.group().reduceSum((w) ->
          w.asw
        )

        trend_chart.width(920).height(400).transitionDuration(1000).margins(
            top: 10
            right: 50
            bottom: 25
            left: 40
          ).dimension(weeks).group(asid_weeks_group).x(d3.time.scale().domain([new Date($("#trend-line-chart").data("start-date")), new Date($("#trend-line-chart").data("end-date"))])).round(d3.time.week.round).xUnits(d3.time.weeks).elasticY(true).renderHorizontalGridLines(true).renderVerticalGridLines(true).brushOn(false).compose([dc.lineChart(trend_chart).group(asid_weeks_group).valueAccessor((d) ->
              d.value
            ).renderArea(false).title((d) ->
              value = d.value
              value = 0  if isNaN(value)
              dateFormat(d.key) + "\n" + numberFormat(value)
            ), dc.lineChart(trend_chart).group(asw_weeks_group).valueAccessor((d) ->
              d.value
            ).renderArea(false).title((d) ->
              value = d.value
              value = 0  if isNaN(value)
              dateFormat(d.key) + "\n" + numberFormat(value)
            )]).xAxis()

          weekly_chart.width(920).height(100).transitionDuration(1000).margins(
            top: 10
            right: 50
            bottom: 25
            left: 40
          ).dimension(weeks).group(asid_weeks_group).x(d3.time.scale().domain([new Date($("#trend-line-chart").data("start-date")), new Date($("#trend-line-chart").data("end-date"))])).round(d3.time.week.round).xUnits(d3.time.weeks).elasticY(true).renderHorizontalGridLines(true).brushOn(true).renderlet((chart) ->
              chart.select("g.y").style("display", "none")
              trend_chart.filter(chart.filter())
            ).on("filtered", (chart) ->
              dc.events.trigger(() ->
                trend_chart.focus(chart.filter())
              )
            ).compose([dc.lineChart(trend_chart).group(asid_weeks_group).valueAccessor((d) ->
              d.value
            ).renderArea(false), dc.lineChart(trend_chart).group(asw_weeks_group).valueAccessor((d) ->
              d.value
            ).renderArea(false)]).xAxis()

        top_asid.dimension(weeks).group((d) ->
          d.asid
        ).columns([(d) ->
          d.date
        , (d) ->
          d.asid
        ]).sortBy((d) ->
          d.asid
        ).order(d3.ascending).renderlet((table) ->
          table.selectAll("#top-asid").classed("info", true)
          table.selectAll(".dc-table-group").remove()
        )

        top_asw.dimension(weeks).group((d) ->
          d.asw
        ).columns([(d) ->
          d.date
        , (d) ->
          d.asid
        ]).sortBy((d) ->
          d.asw
        ).order(d3.ascending).renderlet((table) ->
          table.selectAll("#top-asw").classed("info", true)
          table.selectAll(".dc-table-group").remove()
        )

        #.size(5)

        dc.renderAll()

        # trend_chart.focus([new Date("2012-01-01"), new Date("2014-04-01")])
        # weekly_chart.focus([new Date("2012-01-01"), new Date("2014-04-01")])

        # ).renderArea(false).stack(asw_weeks_group, (d) ->
        #   d.value
        # ).title((d) ->

        $("#selector1, #selector2").click () ->
          if $(this).is(":checked") == false
            $(".sub._" + $(this).data("id")).hide()
          else
            $(".sub._" + $(this).data("id")).show()

        $("#trend-reset-link").click (e) ->
          e.preventDefault()
          weekly_chart.filterAll()
          # trend_chart.focus([new Date("2012-01-01"), new Date("2014-04-01")])
          # weekly_chart.focus([new Date("2012-01-01"), new Date("2014-04-01")])
          dc.redrawAll()
