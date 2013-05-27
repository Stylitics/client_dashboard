class ChartRunsController < ApplicationController
  def update
    chart = Chart.find(params[:chart_id])
    chart_run = chart.runs.find(params[:id])
    new_chart_run = chart_run.dup
    new_chart_run.output = ""
    chart.runs << new_chart_run

    chart_run.accessible = :all

    # this is ugly at this moment. will refactor better later

    [
      :location_opt,
      :brand_add_opt,
      :brand_sub_opt,
      :retailer_add_opt,
      :retailer_sub_opt,
      :style_add_opt,
      :style_sub_opt,
      :color_add_opt,
      :color_sub_opt,
      :pattern_add_opt,
      :pattern_sub_opt,
      :fabric_add_opt,
      :fabric_sub_opt,
      :brand_add_search,
      :brand_sub_search,
      :retailer_add_search,
      :retailer_sub_search,
      :style_add_search,
      :style_sub_search,
      :color_add_search,
      :color_sub_search,
      :pattern_add_search,
      :pattern_sub_search,
      :fabric_add_search,
      :fabric_sub_search
    ].each do |p|
      params[:chart_run][p] = params[:chart_run][p].reject{|l| l.blank?} if params[:chart_run][p].present?
    end

    chart_run.update_attributes params[:chart_run]

    TrendLineWorker.perform_async(chart_run.id)

    respond_to do |format|
      format.js
    end
  end

  def check
    @chart_run = ChartRun.find(params[:id])
    @chart = @chart_run.chart
  end
end
