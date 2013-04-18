class ChartsController < ApplicationController
  def show
    @chart = Chart.find(params[:id])
    if @chart.last_run.output.present?
      render json: @chart.last_run.output
    else
      render json: '{"data": "empty"}'
    end
  end
end
