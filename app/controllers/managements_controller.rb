class ManagementsController < ApplicationController
  before_filter :find_solution
  before_filter :check_manager
    
  def create
    @solution = Solution.find(params[:solution_id])
    @management = @solution.managements.build(params[:management])
    @solution.managements << @management unless @management.user.nil?
    redirect_to :back
  end
  
  def destroy
    @management = @solution.managements.find(params[:id])
    @management.destroy
    redirect_to :back
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