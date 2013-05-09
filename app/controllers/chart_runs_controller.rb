class ChartRunsController < ApplicationController
  def update
    chart = Chart.find(params[:chart_id])
    chart_run = chart.runs.find(params[:id])
    new_chart_run = chart_run.dup
    new_chart_run.output = ""
    chart.runs << new_chart_run

    chart_run.accessible = :all
    params[:chart_run][:location_opt] = params[:chart_run][:location_opt].reject{|l| l.blank?}.join(",") if params[:chart_run][:location_opt].present?
    params[:chart_run][:style_opt] = params[:chart_run][:style_opt].join("")
    params[:chart_run][:retailer_opt] = params[:chart_run][:retailer_opt].join("")
    params[:chart_run][:brand_opt] = params[:chart_run][:brand_opt].join("")

    params[:chart_run][:search_string_join] = "left join item_styles on item_styles.id=items.item_style_id"
    params[:chart_run][:search_string_cond] = "and lower(item_styles.name)='skinny jeans'"
    # logger.info params[:chart_run][:location_opt]
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
