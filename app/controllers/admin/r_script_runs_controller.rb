class Admin::RScriptRunsController < ApplicationController
  def create
    r_script_run = RScriptRun.new
    r_script_run.accessible = :all
    r_script_run.attributes = params[:r_script_run]
    r_script_run.save
    r_script_run.run_script
    redirect_to :back, notice: "Script has been executed. You can view the results bellow."
  end

  def update
    r_script_run = RScriptRun.find(params[:id])
    r_script_run.accessible = :all
    r_script_run.attributes = params[:r_script_run]
    r_script_run.save
    r_script_run.reload
    r_script_run.run_script
    redirect_to :back, notice: "Script has been executed. You can view the results bellow."
  end
end
