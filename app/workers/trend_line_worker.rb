class TrendLineWorker
  include Sidekiq::Worker

  def perform(chart_run_id)
    # chart = Chart.first
    # chart_run = chart.last_run
    chart_run = ChartRun.find(chart_run_id)
    chart = chart_run.chart
    chart.update_attribute :is_running, true

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
    code.gsub!("NULL", NULL)

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
    chart.update_attribute :is_running, false
  end
end