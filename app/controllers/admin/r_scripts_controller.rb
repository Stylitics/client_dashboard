class Admin::RScriptsController < AdminController
  def index
    @r_scripts = RScript.all
  end
end
