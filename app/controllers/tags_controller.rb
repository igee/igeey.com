class TagsController < ApplicationController
  respond_to :html
  before_filter :login_required, :only => [:new,:create,:destroy,:edit,:update]
  before_filter :find_tag, :except => [:index,:new,:create]
  
  def index
    @tags = Tag.paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @tag = Tag.new
  end
  
  def create
    @tag = Tag.new(params[:tag])
    @tag.save if current_user.is_admin?
    respond_with @tag
  end
  
  def show
    @timeline = @tag.taggings.where(['taggable_type != ?','Question']).limit(10).map(&:taggable)
    @questions = @tag.taggings.where(['taggable_type = ?','Question']).limit(10).map(&:taggable)
    @question = Question.new
  end
    
  def edit
  end
  
  def update
    @tag.update_attributes(params[:tag]) if current_user.is_admin?
    respond_with @tag
  end
  
  def questions
    @questions = Question.find_tagged_with(@tag.name).paginate(:page => params[:page], :per_page => 10)
    @question = Question.new
  end
  
  def timeline
    @timeline = @tag.taggings.where(['taggable_type != ?','Question']).paginate(:page => params[:page], :per_page => 10).map(&:taggable)
  end
  
  private
  def find_tag
    if /\d/.match(params[:id])
      @tag = Tag.find(params[:id])
    else
      @tag = Tag.find_by_name(params[:id])
    end
  end
  
end
