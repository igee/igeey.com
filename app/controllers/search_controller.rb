class SearchController < ApplicationController
  def result
    @keywords = params[:keywords].split.join('+')
    @venues = Venue.search(@keywords,:page => (params[:page] || 1),:per_page => 10)
    @users = User.search(@keywords,:page => (params[:page] || 1),:per_page => 10)
    @callings = Calling.search(@keywords,:page => (params[:page] || 1),:per_page => 10)
    @topics = Topic.search(@keywords,:page => (params[:page] || 1),:per_page => 10)
  end

  def more
    @keywords = params[:keywords].split.join('+')
    @items = eval({:venues => "Venue.search(@keywords,:page => params[:page],:per_page => 10)",
                   :users => "User.search(@keywords,:page => params[:page],:per_page => 10)",
                   :callings => "Calling.search(@keywords,:page => params[:page],:per_page => 10)",
                   :topics => "Topic.search(@keywords,:page => params[:page],:per_page => 10)",
                   }[params[:items].to_sym])
    render :layout => false
  end
  
end