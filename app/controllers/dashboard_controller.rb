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
      @chart_run[:gender] = "All"
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

  def trends2
    @chart = Chart.find("trend-line")
    if @chart.last_run
      @chart_run = @chart.last_run
    else
      @chart_run = ChartRun.new
      @chart_run.accessible = :all
      @chart_run[:gender] = "All"
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
