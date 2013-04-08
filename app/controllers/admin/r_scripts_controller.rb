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
    @r_script_run = RScriptRun.new(r_script_id: @r_script.id)
    @r_script.variables.each{|v| @r_script_run[v.to_sym] = ''}
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
