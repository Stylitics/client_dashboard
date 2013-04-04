class WelcomeController < ApplicationController
  def index
    if params[:r] == 'run'
      script = ''
      file = File.new("#{Rails.root}/app/r-scripts/trendLine.r", "r")
      while (line = file.gets)
        script << line
      end
      file.close
      R.eval script
      @lorem = R.x
    end
  end
end
