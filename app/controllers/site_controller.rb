class SiteController < ApplicationController
  before_filter :login_required, :only=> [:unread_comments]
  
  def index
    # group requirements,plans and records to list
    @list = Requirement.limit(10)
    @list += Record.limit(10)
    @list += Plan.limit(10)
    @list = @list[0..10].sort{|x,y| y.created_at <=> x.created_at }    
    @my_plans = current_user.plans.undone if logged_in?
  end
  
  def unread_comments
    @plans = current_user.plans.where(:has_new_comment => true)
    @records = current_user.records.where(:has_new_comment => true)
    @requirements = current_user.requirements.where(:has_new_comment => true)
  end
    
end
