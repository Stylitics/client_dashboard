class DashboardController < ApplicationController
  def index

  end

  def trends
    @chart = Chart.find("trend-line")
    if @chart.last_run
      @chart_run = @chart.last_run
    else
      @chart_run = ChartRun.new
      @chart_run.accessible = :all
      @chart_run[:gender_opt] = "All"
      @chart_run[:lo_age] = 10.to_s
      @chart_run[:hi_age] = 100.to_s
      @chart_run[:student_opt] = "All"
      @chart_run[:location_opt] = ["All"]
      @chart_run[:lo_price] = 0.to_s
      @chart_run[:hi_price] = 100000.to_s
      @chart_run[:no_price_opt] = "Include"
      @chart_run[:influencer_opt] = "Include"
      @chart_run[:staff_opt] = "Include"
      @chart_run[:style_opt] = "All"
      @chart_run[:event_type] = "All"
      @chart_run[:color_opt] = "All"
      @chart_run[:retailer_opt] = "All"
      @chart_run[:brand_opt] = "All"
      @chart_run[:pattern_opt] = "All"
      @chart_run[:fabric_opt] = "All"
      @chart_run[:sort_opt] = "User ID"
      @chart_run[:style_txt] = ""
      @chart_run[:color_txt] = ""
      @chart_run[:brand_txt] = ""
      @chart_run[:retailer_txt] = ""
      @chart_run[:pattern_txt] = ""
      @chart_run[:fabric_txt] = ""
      @chart_run[:who] = "Addings"

      @chart_run[:start_date_txt] = 6.months.ago.strftime("%Y-%m-%d")
      @chart_run[:end_date_txt] = Time.now.strftime("%Y-%m-%d")

      @chart_run[:brand_search] = ""
      @chart_run[:retailer_search] = ""
      @chart_run[:style_search] = ""
      @chart_run[:color_search] = ""
      @chart_run[:pattern_search] = ""
      @chart_run[:fabric_search] = ""
      @chart_run[:event_type_search] = ""

      @chart_run[:search_string_join] = ""
      @chart_run[:search_string_cond] = ""
      @chart.runs << @chart_run
    end

    @brands_collection = ["All", "GAP", "Levi's", "Lorem", "Ipsum", "Dolor"]
    if @chart_run.brand_search.any?
      @chart_run.brand_search.each do |b|
        if b.first(2) == "- "
          @brands_collection[@brands_collection.index{|bc| bc == b[2..(b.length - 1)]}] = b
        end
      end
    end
    @styles_collection = ["Skinny Jeans", "Trench Coat", "Jean Jacket", "Blazer", "Polo Shirt"]
    if @chart_run.style_search.any?
      @chart_run.style_search.each do |s|
        if s.first(2) == "- "
          @styles_collection[@styles_collection.index{|sc| sc == s[2..(s.length - 1)]}] = s
        end
      end
    end
  end

  def trends2
    @chart = Chart.find("trend-line")
    if @chart.last_run
      @chart_run = @chart.last_run
    else
      @chart_run = ChartRun.new
      @chart_run.accessible = :all
      @chart_run[:gender_opt] = "All"
      @chart_run[:lo_age] = 10.to_s
      @chart_run[:hi_age] = 100.to_s
      @chart_run[:student_opt] = "All"
      @chart_run[:location_opt] = ["All"]
      @chart_run[:lo_price] = 0.to_s
      @chart_run[:hi_price] = 100000.to_s
      @chart_run[:influencer_opt] = "Include"
      @chart_run[:staff_opt] = "Include"
      @chart_run[:style_opt] = "All"
      @chart_run[:event_type] = "All"
      @chart_run[:color_opt] = "All"
      @chart_run[:retailer_opt] = "All"
      @chart_run[:brand_opt] = "All"
      @chart_run[:pattern_opt] = "All"
      @chart_run[:fabric_opt] = "All"
      @chart_run[:sort_opt] = "User ID"
      @chart_run[:style_txt] = ""
      @chart_run[:color_txt] = ""
      @chart_run[:brand_txt] = ""
      @chart_run[:retailer_txt] = ""
      @chart_run[:pattern_txt] = ""
      @chart_run[:fabric_txt] = ""

      @chart_run[:start_date_txt] = 6.months.ago.strftime("%Y-%m-%d")
      @chart_run[:end_date_txt] = Time.now.strftime("%Y-%m-%d")
      @chart.runs << @chart_run
    end
  end

  def brandshare

  end

  def top25brands

  end

  def top25retailers

  end

  def top10colorspatternsstyles

  end

  def outfitstreamlookup

  end

  def weathervizualizations

  end
end
