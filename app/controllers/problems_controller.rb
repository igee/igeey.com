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
    respond_with @problem
  end

  def show
    if (current_user && current_user.is_admin?) || @problem.published
      @problems = Problem.published.reverse
      @kase = Kase.new
      @kases = @problem.kases.limit(5)
      @solutions = @problem.solutions.limit(3)
      @comments = @problem.comments
      @following_users = @problem.follows.limit(9).map(&:user)
    else
      redirect_to :root
    end
  end
  
  def map
    @kases = @problem.kases
    latitude_max = @kases.map(&:latitude).max.to_f
    latitude_min = @kases.map(&:latitude).min.to_f
    longitude_max = @kases.map(&:longitude).max.to_f
    longitude_min = @kases.map(&:longitude).min.to_f
    @latitude_center = (latitude_max + latitude_min)/2
    @longitude_center = (longitude_max + longitude_min)/2
    max_distance = [(latitude_max-latitude_min), (longitude_max-longitude_min)].max
    if 0.04 > max_distance
      @map_zoom = 13
    elsif 0.07 > max_distance and max_distance > 0.04
      @map_zoom = 12
    elsif 0.15 > max_distance and max_distance > 0.07
      @map_zoom = 11
    elsif 0.3 > max_distance and max_distance > 0.15
      @map_zoom = 10
    elsif 0.6 > max_distance and max_distance > 0.3
      @map_zoom = 9
    elsif 1.2 > max_distance and max_distance > 0.6
      @map_zoom = 8
    elsif 2.5 > max_distance and max_distance > 1.2
      @map_zoom = 7
    elsif 5.8 > max_distance and max_distance > 2.5
      @map_zoom = 6
    elsif 11 > max_distance and max_distance > 5.8
      @map_zoom = 5
    elsif 22 > max_distance and max_distance > 11
      @map_zoom = 4
    else
      @map_zoom = 3
    end
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
