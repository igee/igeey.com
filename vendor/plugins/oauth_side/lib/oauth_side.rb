require 'oauth_side/ext/hash'
require 'oauth_controller'
require 'oauth_token'


#oauth_config = YAML.load_file "#{Rails.root}/config/oauth/oauth.yml"

OAUTH_CONFIG = {:sites => {}, :model => nil }
#,:model => oauth_config['model'] }

Dir["#{Rails.root}/config/oauth/*.yml"].collect{|f|
  YAML.load_file(f).each_pair{|site,props|
    OAUTH_CONFIG[:sites].update(site.to_sym => {}) unless OAUTH_CONFIG[:sites].has_key? site.to_sym
    if props.class == Hash
      props.each_pair{|k,v|
	    OAUTH_CONFIG[:sites][site.to_sym].update(k.to_sym => v)
	  }
	end
  }
#   if File.basename(f) != /oauth.yml/
}

module Rails
  class << self
    def oauth
	  OAUTH_CONFIG[:sites]
    end
	  def oauth_model
	    OAUTH_CONFIG[:model]
	  end
	  def oauth_model= model
	    OAUTH_CONFIG[:model]=model
	  end
  end
end

require 'oauth_side/model'

Rails.oauth.each_pair{|site,props|
  OauthController.class_eval <<-EOF
    def #{site.to_s}
      begin
        auth_url = OauthToken.request_by(current_user.id,'#{site.to_s}')
        if auth_url =~ /&oauth_callback/
          redirect_to auth_url
        else
          redirect_to auth_url + "&oauth_callback=" + default_callback_url('#{site.to_s}')
        end
      end
    end
  EOF
}
