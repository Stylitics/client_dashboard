class DashboardController < ApplicationController
  def index

  end

  def trends
    @chart = Chart.find("trend-line")
    @chart_run = @chart.last_run
    @chart_run.accessible = :all
    @chart_run[:gender] = "All"
    @chart_run[:student_opt] = "All"
    @chart_run[:location_opt] = "All"
    @chart_run[:influencer_opt] = "Include"
    @chart_run[:staff_opt] = "Include"
    @chart_run[:price] = "All"
    @chart.runs << @chart_run
  end
end
