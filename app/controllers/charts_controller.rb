class ChartsController < ApplicationController
  def show
    @chart = Chart.find(params[:id])
    render json: @chart.r_script.last_run.output
  end
end
