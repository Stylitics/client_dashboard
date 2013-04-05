# encoding: utf-8

namespace :r do

  desc 'Run a demo R script'
  task :trend_line => ['environment'] do
    script = ''
    file = File.new("#{Rails.root}/app/r/trendLine 2.r", "r")
    while (line = file.gets)
      script << line
    end
    file.close
    script << "\n\n"
    file = File.new("#{Rails.root}/app/r/getTrend 2.r", "r")
    while (line = file.gets)
      script << line
    end
    file.close
    # R.eval script

    File.open("#{Rails.root}/app/r/trend 2.r", 'w') {|f| f.write(script) }
  end

end
