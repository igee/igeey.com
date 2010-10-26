class SiteController < ApplicationController
  def index
    @list = Requirement.limit(10)
    @list += Record.limit(10)
    @list += Plan.limit(10)
    @list = @list[0..10].sort{|x,y| y.created_at <=> x.created_at }    
    @myplans = current_user.plans.select{|p| p.record.nil?} if logged_in?
  end

end
