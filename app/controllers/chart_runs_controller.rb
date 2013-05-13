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
        params[:chart_run][p] = params[:chart_run][p].reject{|l| l.blank?}.join(",") if params[:chart_run][p].present?
      end

      # this is really ugly
      if params[:chart_run][:brand_search].present?
        params[:chart_run][:search_string_join] = "LEFT JOIN brands ON brands.id=items.brand_id"
        "AND (brands.name='brandName')"
        "and lower(item_styles.name)='skinny jeans'"
        "AND ( (brands.name='brandName1') OR (brands.name='brandName2') OR (brands.name='brandName2') )"
        "AND ( (brands.name='brandName1') OR (brands.name<>'brandName2') OR (brands.name='brandName2') )"
      elsif params[:chart_run][:color_search].present?
        params[:chart_run][:search_string_join] = "LEFT JOIN colors ON (colors.id=items.color_id OR colors.id=items.color2_id OR colors.id=items.color3_id)"
      # elsif params[:chart_run][:event_type_search].present?
      #   params[:chart_run][:search_string_join] = ""
      elsif params[:chart_run][:fabric_search].present?
        params[:chart_run][:search_string_join] = "LEFT JOIN fabrics ON fabrics.id=items.fabric_id "
      elsif params[:chart_run][:pattern_search].present?
        params[:chart_run][:search_string_join] = "LEFT JOIN patterns ON (patterns.id=items.pattern_id OR patterns.id=items.pattern2_id)"
      elsif params[:chart_run][:retailer_search].present?
        params[:chart_run][:search_string_join] = "LEFT JOIN retailers ON retailers.id=items.retailer_id"
      elsif params[:chart_run][:style_search].present?
        params[:chart_run][:search_string_join] = "left join item_styles on item_styles.id=items.item_style_id"
        params[:chart_run][:search_string_cond] = "and lower(item_styles.name)='skinny jeans'"
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
