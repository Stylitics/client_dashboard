class ChartRunsController < ApplicationController
  def update
    chart = Chart.find(params[:chart_id])
    chart_run = chart.runs.find(params[:id])
    new_chart_run = chart_run.dup
    new_chart_run.output = ""
    chart.runs << new_chart_run

    chart_run.accessible = :all

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
      :occasion_add_opt,
      :occasion_sub_opt,
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
      :fabric_sub_search,
      :occasion_add_search,
      :occasion_sub_search
    ].each do |p|
      params[:chart_run][p] = params[:chart_run][p].reject{|l| l.blank?} if params[:chart_run][p].present?
    end

    chart_run.update_attributes params[:chart_run]

    code = chart.r_script.code

    # this is dupplicate. will refactor later on

    # SQL connection
    code.gsub!("{!hostVar!}", SQL_HOST)
    code.gsub!("{!portVar!}", SQL_PORT.to_s)
    code.gsub!("{!dbnameVar!}", SQL_DB)
    code.gsub!("{!userVar!}", SQL_USER)
    code.gsub!("{!passVar!}", SQL_PASS)
    # end SQL connection

    code.scan(/\{\{(.*?)\}\}/).each do |v|
      injected_value = chart_run[v[0].camelize(:lower).underscore.to_sym].to_a.join(",")
      injected_value = "NULL" if injected_value.blank?
      code.gsub!("{{#{v[0].camelize(:lower)}}}", injected_value)
    end
    # remove "NULL"s
    code.gsub!('"NULL"', "NULL")

    code.gsub!('{#json_output#}', "#{Rails.root}/tmp/runs/#{chart_run.id}.json")
    File.open("#{Rails.root}/tmp/runs/#{chart_run.id}.r", 'w') {|f| f.write(code) }

    e = system "Rscript '#{Rails.root}/tmp/runs/#{chart_run.id}.r'"

    json_output = ''
    if File.exists?("#{Rails.root}/tmp/runs/#{chart_run.id}.json")
      f = File.new("#{Rails.root}/tmp/runs/#{chart_run.id}.json", "r")
      while (l = f.gets)
        json_output << l
      end
      f.close
    end

    chart_run.output = JSON.pretty_generate(JSON.parse(json_output))
    chart_run.save

    redirect_to trends_path
  end
end
