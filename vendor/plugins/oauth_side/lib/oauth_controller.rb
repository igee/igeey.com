class OauthController < ApplicationController
  def initialize
  end

  def default_callback_url site
    URI.encode url_for(:controller => 'oauth', :action => 'accept')
  end
    
  def accept
    record = OauthToken.find_by_user_id_and_request_key(current_user.id, params[:oauth_token])

    access = record.authorize params[:oauth_verifier]
    redirect_to '/' #TODO 暂时返回网站主页
  end

end
