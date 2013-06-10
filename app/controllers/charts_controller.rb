class ChartsController < ApplicationController
  def show
    if ["top-25-brands-and-retailers", "top-10"].include? params[:id]
      temp = params[:id] == "top-25-brands-and-retailers" ? "temp" : "temp2"
      render file: "#{Rails.root}/app/assets/javascripts/#{temp}.json"
    else
      @chart = Chart.find(params[:id])
      if @chart.last_run.output.present?
        render json: @chart.last_run.output
      else
        render json: '{"data": "empty"}'
      end
    end
  end
end
