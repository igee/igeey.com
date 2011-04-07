class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @tag.tag_list = Tag.limit(10)
    #if ['Topic','Photo','Calling','Saying'].include?(params[:filter])
    #  @timeline = params[:filter].constantize.tagged_with(@tag.name)
    #  @filter_name = {'Topic'=>'故事','Photo'=>'照片','Calling'=>'召集','Saying'=>'报到'}[params[:filter]]
    #else 
    #end
    @timeline = (Topic.tagged_with(@tag.name) + Calling.tagged_with(@tag.name) + Photo.tagged_with(@tag.name))
    @timeline.uniq.sort{|x,y| y.created_at  <=> x.created_at  }[0..9]
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
