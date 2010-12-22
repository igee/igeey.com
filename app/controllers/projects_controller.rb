class ProjectsController < ApplicationController
  respond_to :html
  before_filter :login_required,   :except => [:show]
  before_filter :find_project,       :except => [:new,:create]
  before_filter :check_permission, :only => [:destroy,:update]
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    @project.user = current_user
    @project.save
    respond_with @project
  end

  def update
    @project.update_attributes(params[:project]) if @project.user_id == current_user.id
    redirect_to :back
  end

  def destroy
    @project.destroy if @project.user_id == current_user.id
    redirect_to :back
  end

  def show
    render :layout => false if params[:layout] == 'false'
  end
  
  private
  
  def find_project
    @project = Project.find(params[:id])
  end
  
  def check_permission
    redirct_to :back unless current_user.is_admin
  end

end
