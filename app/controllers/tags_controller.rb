class TagsController < ApplicationController
  respond_to :html
  before_filter :login_required, :except => [:show,:name]
  before_filter :find_tag, :except => [:index, :new, :create,:name]
  
  def show
    @tag.tag_list = Tag.limit(10).map(&:name)
    #if ['Topic','Photo','Calling','Saying'].include?(params[:filter])
    #  @timeline = params[:filter].constantize.find_tagged_with(@tag.name)
    #  @filter_name = {'Topic'=>'故事','Photo'=>'照片','Calling'=>'召集','Saying'=>'报到'}[params[:filter]]
    #else 
    #end
    @timeline = @tag.with_taggings.limit(10).map(&:taggedable).map(&:event)
  end
  
  def edit
  end
  
  def update
    @tag.update_attributes(params[:tag]) if current_user.is_admin?
    respond_with @tag
  end
  
  def name
    begin
      @tag = Tag.find_by_name(params[:name])
      redirect_to tag_path(@tag,:filter => params[:filter])
    rescue ActiveRecord::RecordNotFound
      redirect_to tags_path
    end  
  end
  
  
  private
  def find_tag
    @tag = Tag.find(params[:id])
  end
  
end
