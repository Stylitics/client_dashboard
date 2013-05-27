class ChartRunsController < ApplicationController
  def update
    chart = Chart.find(params[:chart_id])
    chart_run = chart.runs.find(params[:id])
    new_chart_run = chart_run.dup
    new_chart_run.output = ""
    chart.runs << new_chart_run

    chart_run.accessible = :all

    # this is ugly at this moment. will refactor better later

    case chart.slug
    when "trend-line"
      [:location_opt, :style_opt, :retailer_opt, :brand_opt].each do |p|
        params[:chart_run][p] = params[:chart_run][p].reject{|l| l.blank?}.join(",") if params[:chart_run][p].present?
      end

      [:brand_search, :color_search, :event_type_search, :fabric_search, :pattern_search, :retailer_search, :style_search].each do |s|
        params[:chart_run][s] = params[:chart_run][s].reject{|l| l.blank?}
      end
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
