class ChartsController < ApplicationController
  def show
    render file: "#{Rails.root}/app/assets/javascripts/temp.json"
    # @chart = Chart.find(params[:id])
    # if @chart.last_run.output.present?
    #   render json: @chart.last_run.output
    # else
    #   render json: '{"data": "empty"}'
    # end
  end
end
