require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  add_oauth  # add dynamic method for confirmation of oauth status
  
  belongs_to  :geo
  
  has_attached_file :avatar,:styles => {:_48x48 => ["48x48#",:png],:_72x72 => ["72x72#",:png]},
                            :default_url=>"/defaults/:attachment/:style.png",
                            :default_style=> :_48x48,
                            :url=>"/media/:attachment/:id/:style.:extension"
                            
  has_many :records
  has_many :plans
  has_many :requirements,   :foreign_key => :publisher_id
  has_many :venues,         :foreign_key => :creator_id
  has_many :followings,     :class_name => "Follow",:foreign_key => :user_id
  has_many :follows,        :as => :followable, :dependent => :destroy
  has_many :followers,      :through => :follows, :source => :user
  # set_table_name 'users'

  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 1..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }
                    
  validates :avatar_file_name,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,:avatar,:avatar_file_name,:geo_id


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) || find_by_email(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def time_counter
    self.records.map(&:time).compact.sum
  end
  
  def money_counter
    self.records.map(&:money).compact.sum
  end

  def goods_counter
    self.records.map(&:goods).compact.sum
  end

  def following?(followable)
    !self.followings.where(:followable_id => followable.id,:followable_type => followable.class).limit(1).blank?
  end

  def has_unread_record_comment?
    !self.records.where(:has_new_comment => true).blank?
  end

  def has_unread_plan_comment?
    !self.plans.where(:has_new_comment => true).blank?
  end
  
  def has_unread_requirement_comment?
    !self.requirements.where(:has_new_comment => true).blank?
  end
  
  # Use OAuth::AccessToken to access oauth api. powered by oauth_side 
  def send_to_douban_miniblog(message)
    content = "<?xml version='1.0' encoding='UTF-8'?><entry xmlns:ns0='http://www.w3.org/2005/Atom' xmlns:db='http://www.douban.com/xmlns/'><content>#{message}</content></entry>"
    self.douban.post('http://api.douban.com/miniblog/saying',content, {"Content-Type" =>  "application/atom+xml"}  )
  end
  
  protected
  
end
