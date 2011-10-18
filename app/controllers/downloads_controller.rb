class DownloadsController < ApplicationController
  before_filter :find_solution
  before_filter :check_manager
  
  
  def new
    @download = @solution.downloads.build
  end
    
  def create
    @download = @solution.downloads.build(params[:download])
    if @download.save
      redirect_to solution_path(@solution)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @download = @solution.downloads.find(params[:id])
    @download.destroy
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      redirect_to @solution
    end
  end
  
  private
  
  def find_solution
    @solution = Solution.find(params[:solution_id])
  end
  
  def check_manager
    unless current_user && @solution.managed_by?(current_user)
      render :text => '请用管理员登录后进入'
    end
  end
    
end