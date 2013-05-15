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

      # this is really ugly
      if params[:chart_run][:brand_search].present?
        params[:chart_run][:search_string_join] = "LEFT JOIN brands ON brands.id=items.brand_id"
        if params[:chart_run][:brand_search].length == 1
          params[:chart_run][:search_string_cond] = "AND (lower(brands.name)='#{params[:chart_run][:brand_search][0].downcase}')"
        else
          add = []
          sub = []
          params[:chart_run][:brand_search].each do |brand|
            if brand.first(2) == "- "
              sub << "(lower(brands.name) <> '#{brand[2..(brand.length - 1)].downcase}')"
            else
              add << "(lower(brands.name) = '#{brand.downcase}')"
            end
          end
          if sub.any?
            search_string_cond = "and (#{add.join(" or ")} and #{sub.join(" and ")})"
          else
            search_string_cond = "and (#{add.join(" or ")})"
          end
          params[:chart_run][:search_string_cond] = search_string_cond
        end
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
        if params[:chart_run][:style_search].length == 1
          params[:chart_run][:search_string_cond] = "AND lower(item_styles.name)='#{params[:chart_run][:style_search][0].downcase}'"
        else
          add = []
          sub = []
          params[:chart_run][:style_search].each do |style|
            if style.first(2) == "- "
              sub << "(lower(item_styles.name) <> '#{style[2..(style.length - 1)].downcase}')"
            else
              add << "(lower(item_styles.name) = '#{style.downcase}')"
            end
          end
          if sub.any?
            search_string_cond = "and (#{add.join(" or ")} and #{sub.join(" and ")})"
          else
            search_string_cond = "and (#{add.join(" or ")})"
          end
          params[:chart_run][:search_string_cond] = search_string_cond
        end
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
