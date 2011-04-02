class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    
  end
  
  def name
    begin
      @tag = Tag.find_by_name(params[:name])
      redirect_to tag_path(@tag)
    rescue ActiveRecord::RecordNotFound
      redirect_to tags_path
    end  
  end
end
