class MyigeeController < ApplicationController
  before_filter :login_required
  
  def index
    @user = current_user
  end
end
