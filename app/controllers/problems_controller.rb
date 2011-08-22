class ProblemsController < ApplicationController
  respond_to :html
  #before_filter :login_required, :except => [:show, :index]
  before_filter :find_problem, :except => [:new,:create,:index,:before_create,:thanks]
  before_filter :check_admin,  :only => [:index]
  
  def index
    @problems = Problem.all
  end
  
  def new
    unless params[:keywords].blank?
      @keywords = params[:keywords].split.join('+')
      @problems = Problem.search(@keywords)
    else
      @problems = []
    end
    @problem = Problem.new(:title =>params[:keywords])
  end

  def create
    @problem = Problem.new(params[:problem])
    @problem.save
    #respond_with @problem
    @problem.send_new_problem if @problem.save
    flash[:dialog] = "<a href=#{thanks_problems_path} class='open_dialog' title='添加成功'>问题添加成功</a>"
    redirect_to :root
  end
  
  def edit
    @problems = Problem.all
  end
  
  def update
    @problem.update_attributes(params[:problem]) if current_user.is_admin
  end

  def show
    if (current_user && current_user.is_admin?) || INDEX_PROBLEMS['problem_ids'].split(',').include?(params[:id])
      @problems = Problem.where(:id => INDEX_PROBLEMS['problem_ids'].split(','))
      @kase = Kase.new
      @kases = @problem.kases.limit(5)
      @comments = @problem.comments
      @following_users = @problem.follows.limit(9).map(&:user)
    else
      redirect_to :root
    end
  end
  
  def map
    @kases = @problem.kases
 end
  
  def followers
    @items = @problem.follows.map(&:user).paginate(:page => params[:page], :per_page => 10)
    @title = "关心#{@problem.title}的用户："
    render 'see_all'
  end
  
  def thanks
    if params[:layout] == 'false'
      render :layout => false
    end
  end
  
  private
  def find_problem
    @problem = Problem.find(params[:id])
  end
end
