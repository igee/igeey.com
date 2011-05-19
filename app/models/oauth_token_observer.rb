class OauthTokenObserver < ActiveRecord::Observer
  def after_update(oauth_token)
    if oauth_token.user_id #For anonymous oauth
      User.find(oauth_token.user_id).check_badge_condition_on("#{oauth_token.site}_count") if oauth_token.access_secret.present?
    end
  end
  
  def before_save(oauth_token)
    if oauth_token.unique_id.nil? && oauth_token.site.present? && oauth_token.access_token.present?
      @unique_id = oauth_token.get_site_unique_id
      (oauth_token.unique_id = @unique_id) unless @unique_id.nil?
    end
  end 
  
end
