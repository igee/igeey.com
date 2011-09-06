class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  
  def get_url_host
    unless self.url.empty?
      host = (/https?:\/\/(.+?)\//.match(self.url).nil? ? /https?:\/\/(.+?)$/.match(self.url)[1] : /https?:\/\/(.+?)\//.match(self.url)[1])
    else
      host = 'www.igeey.com'
    end
  end
end
