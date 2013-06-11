class ChartsController < ApplicationController
  def show
    if params[:id] == "top-25-brands-and-retailers"
      temp = "temp"
    elsif params[:id] == "top-10"
      temp = "temp2"
    else
      temp = "temp3"
    end
    render file: "#{Rails.root}/app/assets/javascripts/#{temp}.json"
    # @chart = Chart.find(params[:id])
    # if @chart.last_run.output.present?
    #   render json: @chart.last_run.output
    # else
    #   render json: '{"data": "empty"}'
    # end
  end
end
