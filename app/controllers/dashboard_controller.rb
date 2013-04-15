class DashboardController < ApplicationController
  def index

  end

  def trends
    @chart = Chart.find("trend-line")
    @chart_run = ChartRun.new(chart_id: @chart.id)
    @chart_run.accessible = :all
    @chart_run[:gender] = "All"
    @chart_run[:student] = "All"
    @chart_run[:location] = "All"
    @chart_run[:influencer] = "Include"
    @chart_run[:staff] = "Include"
    @chart_run[:price] = "all"
    @chart.runs << @chart_run
  end
end
