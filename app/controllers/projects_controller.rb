class ProjectsController < ApplicationController
  respond_to :html,:json
  before_filter :login_required,   :except => [:show,:venues,:records]
  before_filter :find_project,       :except => [:new,:create]
  before_filter :check_permission, :only => [:destroy,:update,:new,:edit]
  
  def new
    @project = Project.new
    @actions = Action.for_project
  end
  
  def edit
    @actions = Action.for_project
  end
  
  def create
    @project = Project.new(params[:project])
    @project.user = current_user
    update_tools
    @project.save
    respond_with @project
  end

  def update
    @project.update_attributes(params[:project]) if current_user.is_admin
    update_tools
    @project.save
    @actions = Action.for_project
    respond_with @project
  end

  def destroy
    @project.destroy if @project.user_id == current_user.id
    redirect_to :back
  end

  def show
    @records = @project.records
    @venues = @records.map(&:venue).uniq
    @followers = @project.followers
    render :layout => false if params[:layout] == 'false'
  end
  
  def records
    @records = @project.records
    respond_with @records
  end
  
  def venues
    @venues = @project.records.map(&:venue).uniq
    respond_with @venues
  end
  
  private
  
  def find_project
    @project = Project.find(params[:id])
  end
  
  def check_permission
    redirect_to :root unless current_user.is_admin
  end
  
  def update_tools
    Action.for_project.each do |a|
      if params[a.slug]
        @project.tools.build(:action_id => a.id)
      else
        @project.tools.where(:action_id => a.id).map(&:destroy)
      end
    end
  end

end
