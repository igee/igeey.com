class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @photos = Photo.tagged_with(@tag.name)
    @topics = Topic.tagged_with(@tag.name)
    @callings = Calling.tagged_with(@tag.name)
    @tags = Tag.limit(10)
  end
  
  def name
    begin
      @tag = Tag.find_by_name(params[:name])
      redirect_to tag_path(@tag,:filter => params[:filter])
    rescue ActiveRecord::RecordNotFound
      redirect_to tags_path
    end  
  end
end
