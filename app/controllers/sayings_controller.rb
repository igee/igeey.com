class SayingsController < ApplicationController
  before_filter :login_required
  before_filter :find_solution
  
  def new
    @saying = @solution.sayings.build
  end
  
  def create
    @saying = @solution.sayings.build(params[:saying])
    @saying.user_id = current_user.id
    if @saying.save
      redirect_to solution_path(@solution)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @saying = Saying.find(params[:id])
    @saying.destroy if @saying.owned_by?(current_user)
    if params[:back_path].present?
      redirect_to params[:back_path]
    else
      respond_with @saying
    end
  end
  
  def show
    @saying = Saying.find(params[:id])
    @venue = @saying.venue
    @comments = @saying.comments
  end
  
  private
  
  def find_solution
    @solution = Solution.find(params[:solution_id])
  end

end
