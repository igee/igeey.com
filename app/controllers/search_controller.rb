class SearchController < ApplicationController
  def result
    unless params[:keywords].blank?
    @keywords = params[:keywords].split.join('+')
      [Venue,User].each do |model|
        eval("@#{model.name.downcase}s = #{model.name}.search(@keywords,:page => (params[:page] || 1),:per_page => 10)")
      end
    end
  end

  def more
    @keywords = params[:keywords].split.join('+')
    @items = eval({:venues => "Venue.search(@keywords,:page => params[:page],:per_page => 10)",
                   :users => "User.search(@keywords,:page => params[:page],:per_page => 10)",
                   }[params[:items].to_sym])
    render :layout => false
  end
  
end