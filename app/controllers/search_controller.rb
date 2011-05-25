class SearchController < ApplicationController
  def result
    @result = {}
    unless params[:keywords].blank?
    @keywords = params[:keywords].split.join('+')
      [Venue,User].each do |model|
        @result[model.name.downcase.to_sym] = model.search(@keywords,:order => :follows_count,:sort_mode => :desc,:page => (params[:page] || 1),:per_page => 10)
      end
    end
  end
  
  def tags
    unless params[:keywords].blank?
      @keywords = params[:keywords].split.join('+')
      @tags = Tag.search(@keywords)
    else
      @tags = []
    end
  end
  
  def more
    @result = {}
    @keywords = params[:keywords].split.join('+')
    @model =  {:venue => Venue,:user => User}[params[:items].to_sym]
    @items = @model.search(@keywords,:order => :follows_count,:sort_mode => :desc,:page => params[:page],:per_page => 10)
    render :layout => false
  end
end
