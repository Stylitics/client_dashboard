class ChartRunsController < ApplicationController
  def update
    chart = Chart.find(params[:chart_id])
    chart_run = chart.runs.find(params[:id])
    new_chart_run = chart_run.dup
    new_chart_run.output = ""
    chart.runs << new_chart_run

    chart_run.update_attributes params[:chart_run]

    TrendLineWorker.perform_async(chart_run.id)

    respond_to do |format|
      format.js
    end
  end

  def check
    @chart_run = ChartRun.find(params[:id])
    @chart = @chart_run.chart
    @not_ready = true if @chart.is_running?
  end
end
