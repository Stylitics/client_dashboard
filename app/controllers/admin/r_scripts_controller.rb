class Admin::RScriptsController < AdminController
  def index
    @r_scripts = RScript.all
  end

  def new
    @r_script = RScript.new
  end

  def create
    @r_script = RScript.new(params[:r_script])
    if @r_script.save
      redirect_to [:admin, @r_script], notice: 'R Script created.'
    else
      flash.now[:error] = "R Script couldn't be created."
      render action: 'new'
    end
  end

  def show
    @r_script = RScript.find(params[:id])
    @r_script_run = @r_script.last_run
    @r_script.variables.each do |v|
      @r_script_run[v.underscore.to_sym] = '' if @r_script_run[v.to_sym].blank?
    end
  end

  def preview
    @r_script = RScript.find(params[:id])
    send_data @r_script.last_run.generated_script, filename: "#{@r_script.name.parameterize}.r"
  end

  def clear
    @r_script = RScript.find(params[:id])
    @r_script.runs.destroy_all
    redirect_to :back, notice: 'Runs for this script have been cleared.'
  end

  def activate
    @r_script = RScript.find(params[:id])
    m = true if params[:m].blank?
    @r_script.activate(m)
    redirect_to :back, notice: m == true ? 'This script have been activated.' : 'This script have been de-activated.'
  end

  def edit
    @r_script = RScript.find(params[:id])
  end

  def update
    @r_script = RScript.find(params[:id])
    if @r_script.update_attributes(params[:r_script])
      redirect_to [:admin, @r_script], notice: 'R Script updated.'
    else
      flash.now[:error] = "R Script couldn't be updated."
      render action: 'new'
    end
  end

  def destroy
    r_script = RScript.find(params[:id])
    r_script.destroy
    redirect_to admin_r_scripts_path, notice: 'R Script destroyed.'
  end
end
