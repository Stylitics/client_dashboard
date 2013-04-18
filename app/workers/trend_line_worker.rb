class TrendLineWorker
  include Sidekiq::Worker

  def perform(chart_run_id)
    chart_run = ChartRun.find(chart_run_id)
    chart = chart_run.chart
    chart.update_attribute :is_running, true

    code = chart.r_script.code

    # temp
    code.gsub!("{{hostVar}}", "localhost")
    code.gsub!("{{portVar}}", "5432")
    code.gsub!("{{dbnameVar}}", "stylitics-dev")
    code.gsub!("{{userVar}}", "catalystww")
    code.gsub!("{{passVar}}", "")

    code.gsub!("{{loAge}}", "10")
    code.gsub!("{{hiAge}}", "100")
    code.gsub!("{{loPrice}}", "0")
    code.gsub!("{{hiPrice}}", "100000")
    code.gsub!("{{startDateTxt}}", "2013-01-01")
    code.gsub!("{{endDateTxt}}", "2013-04-01")
    code.gsub!("{{expensiveOpt}}", "Include")
    code.gsub!("{{styleOpt}}", "All")
    code.gsub!("{{eventType}}", "All")
    code.gsub!("{{colorOpt}}", "All")
    code.gsub!("{{retailerOpt}}", "All")
    code.gsub!("{{brandOpt}}", "All")
    code.gsub!("{{patternOpt}}", "All")
    code.gsub!("{{fabricOpt}}", "All")
    code.gsub!("{{sortOpt}}", "User ID")

    code.gsub!("{{styleTxt}}", "")
    code.gsub!("{{colorTxt}}", "")
    code.gsub!("{{brandTxt}}", "")
    code.gsub!("{{retailerTxt}}", "")
    code.gsub!("{{patternTxt}}", "")
    code.gsub!("{{fabricTxt}}", "")
    # end temp

    code.scan(/\{\{(.*?)\}\}/).each do |v|
      code.gsub!("{{#{v[0].camelize(:lower)}}}", chart_run[v[0].camelize(:lower).underscore.to_sym])
    end

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