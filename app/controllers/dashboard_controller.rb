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

      @chart_run[:event_opt] = "Addings"

      @chart_run[:gender_opt] = "All"
      @chart_run[:low_age_opt] = 10.to_s
      @chart_run[:high_age_opt] = 100.to_s
      @chart_run[:student_opt] = "All"
      @chart_run[:location_opt] = ["All"]
      @chart_run[:low_price_opt] = 0.to_s
      @chart_run[:high_price_opt] = 100000.to_s
      @chart_run[:no_price_opt] = "Include"
      @chart_run[:influencer_opt] = "Include"
      @chart_run[:staff_opt] = "Include"
      @chart_run[:sort_opt] = "User ID"
      @chart_run[:brand_add_opt] = ["All"]
      @chart_run[:brand_sub_opt] = [""]
      @chart_run[:retailer_add_opt] = ["All"]
      @chart_run[:retailer_sub_opt] = [""]
      @chart_run[:style_add_opt] = ["All"]
      @chart_run[:style_sub_opt] = [""]
      @chart_run[:color_add_opt] = ["All"]
      @chart_run[:color_sub_opt] = [""]
      @chart_run[:pattern_add_opt] = ["All"]
      @chart_run[:pattern_sub_opt] = [""]
      @chart_run[:fabric_add_opt] = ["All"]
      @chart_run[:fabric_sub_opt] = [""]
      @chart_run[:occasion_add_opt] = ["All"]
      @chart_run[:occasion_sub_opt] = [""]

      @chart_run[:start_date_opt] = 6.months.ago.strftime("%Y-%m-%d")
      @chart_run[:end_date_opt] = Time.now.strftime("%Y-%m-%d")

      @chart_run[:brand_add_search] = []
      @chart_run[:brand_sub_search] = []
      @chart_run[:retailer_add_search] = []
      @chart_run[:retailer_sub_search] = []
      @chart_run[:style_add_search] = []
      @chart_run[:style_sub_search] = []
      @chart_run[:color_add_search] = []
      @chart_run[:color_sub_search] = []
      @chart_run[:pattern_add_search] = []
      @chart_run[:pattern_sub_search] = []
      @chart_run[:fabric_add_search] = []
      @chart_run[:fabric_sub_search] = []
      @chart_run[:occasion_add_search] = []
      @chart_run[:occasion_sub_search] = []

      @chart.runs << @chart_run
    end

    @brand_collection = ["GAP", "Levi's", "Lorem", "Ipsum", "Dolor"]
    @retailer_collection = ["Levi's", "Retailer 1"]
    @style_collection = ["Skinny Jeans", "Trench Coat", "Jean Jacket", "Blazer", "Polo Shirt"]
    @color_collection = ["Blue", "Black", "Red"]
    @pattern_collection = ["Pattern 1", "Pattern 2", "Pattern 3"]
    @fabric_collection = ["Fabric 1", "Fabric 2", "Fabric 3"]
    @occasion_collection = ["Occasion 1", "Occasion 2", "Occasion 3", "Occasion 4", "Occasion 5"]
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
