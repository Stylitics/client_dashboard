class DashboardController < ApplicationController
  before_filter :setup_filter

  def trends
    chart = Chart.find("trend-line")
    setup_chart(chart)
  end

  def brand_share

  end

  def top_25_brands_and_retailers
    chart = Chart.find("top-25-brands-and-retailers")
    setup_chart(chart)
  end

  def top_10

  end

  def outfit_stream

  end

  def weather

  end

private

  def setup_filter
    %w(brand_collection retailer_collection style_collection color_collection pattern_collection fabric_collection occasion_collection).each do |v|
      file = open("#{Rails.root}/app/data/#{v}.json")
      json = JSON.parse(file.read)
      ar = []
      json.each do |v|
        ar << v["name"]
      end
      instance_variable_set("@#{v}", ar)
    end
  end

  def setup_chart(chart)
    @chart = chart
    if @chart.last_run
      @chart_run = @chart.last_run
    else
      @chart_run = ChartRun.new
      @chart_run.accessible = :all

      @chart_run[:event_opt] = "Addings"

      @chart_run[:gender_opt] = "All"
      @chart_run[:low_age_opt] = 10.to_s
      @chart_run[:high_age_opt] = 100.to_s
      @chart_run[:student_opt] = "NULL"
      @chart_run[:location_opt] = ["All"]
      @chart_run[:low_price_opt] = 0.to_s
      @chart_run[:high_price_opt] = 100000.to_s
      @chart_run[:no_price_opt] = "NULL"
      @chart_run[:influencer_opt] = "NULL"
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
  end
end
