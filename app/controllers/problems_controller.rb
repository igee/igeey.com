class ProblemsController < ApplicationController
  respond_to :html
  #before_filter :login_required, :except => [:show, :index]
  before_filter :find_problem, :except => [:new,:create,:index,:before_create,:thanks]
  before_filter :check_admin,    :except => [:new,:create,:thanks]
  
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
  
  def show
    @kase = Kase.new
    @kases = @problem.kases.where("photo_file_name is not null")[0..2]
    @comments = @problem.comments
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
