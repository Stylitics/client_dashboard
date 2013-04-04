class WelcomeController < ApplicationController
  def index
    script = ''
    file = File.new("#{Rails.root}/app/r-scripts/test.r", "r")
    while (line = file.gets)
      script << line
    end
    file.close
    R.eval script
    @lorem = R.pull 'x'
  end
end
