class OauthTokenObserver < ActiveRecord::Observer
  def after_update(oauth_token)
    if oauth_token.user_id #For anonymous oauth
      User.find(oauth_token.user_id).check_badge_condition_on("#{oauth_token.site}_count") if oauth_token.access_secret.present?
    end
  end
end
