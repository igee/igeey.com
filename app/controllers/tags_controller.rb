class TagsController < ApplicationController
  respond_to :html
  before_filter :login_required, :only => [:new,:create,:destroy,:edit,:update]
  before_filter :find_tag, :except => [:index,:new,:create]
  
  def index
    @tags = Tag.paginate(:page => params[:page], :per_page => 20)
  end
  
  def new
    @tag = Tag.new
  end
  
  def create
    @tag = Tag.new(params[:tag])
    @tag.save
    respond_with @tag
  end
  
  def show
    @timeline = @tag.taggeds.where(['taggable_type not in (?)',['Question','Tag']]).limit(11).map(&:taggable)
    @questions = @tag.taggeds.where(['taggable_type = ?','Question']).limit(11).map(&:taggable)
    @question = Question.new
    @tags = Tag.find_tagged_with(@tag.name)
  end
    
  def edit
  end
  
  def update
    @tag.update_attributes(params[:tag]) 
    respond_with @tag
  end
  
  def questions
    @questions = @tag.taggeds.where(['taggable_type = ?','Question']).paginate(:page => params[:page], :per_page => 10).map(&:taggable)
    @question = Question.new
  end
  
  def timeline
    @timeline = @tag.taggeds.where(['taggable_type != ?','Question']).paginate(:page => params[:page], :per_page => 10).map(&:taggable)
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
