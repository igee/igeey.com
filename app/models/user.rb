require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  add_oauth  # add dynamic method for confirmation of oauth status
  
  belongs_to  :geo
  has_many    :projects                            
  has_many :records,        :dependent => :destroy
  has_many :plans,          :dependent => :destroy
  has_many :callings,       :dependent => :destroy
  has_many :venues,         :foreign_key => :creator_id,:dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :topics,         :dependent => :destroy
  has_many :photos,         :dependent => :destroy
  has_many :grants,         :dependent => :destroy
  has_many :followings,     :class_name => "Follow",:foreign_key => :user_id
  has_many :follows,        :as => :followable, :dependent => :destroy
  has_many :followers,      :through => :follows, :source => :user
  has_many :sayings,       :dependent => :destroy
  has_many :syncs,          :dependent => :destroy
  
  has_attached_file :avatar,:styles => {:_48x48 => ["48x48#",:png],:_72x72 => ["72x72#",:png]},
                            :default_url=>"/defaults/:attachment/:style.png",
                            :default_style=> :_48x48,
                            :url=>"/media/:attachment/:id/:style.:extension"
  
  default_scope :order => 'follows_count DESC'
  
  validates :login, :uniqueness => true,
                    :length     => { :within => 1..40,:message => '用户名字数在1至40之间'},
                    :format     => { :with => Authentication.login_regex, :message => '用户名请使用中文和常见的字符' }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100},
                    :allow_nil  => true

  validates :email, :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => '邮箱格式有误'},
                    :length     => { :within => 6..100 ,:message => '邮箱不足6位'}
                    
  validates :avatar_file_name,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  
  attr_accessible :login, :email, :name, :password, :password_confirmation,:avatar,:avatar_file_name,:geo_id,:signature,:use_local_geo


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
  
  #def id_count  #hack for top 100 earlier user badge
    #200 - self.id
  #end
  
  def undone_plans_count
    self.plans.undone.size
  end
  
  def time_count
    self.records.map(&:time).compact.sum
  end
  
  def money_count
    self.records.map(&:money).compact.sum
  end

  def online_count
    self.records.map(&:online).compact.sum
  end
  
  def goods_count
    self.records.map(&:goods).compact.sum
  end
  
  def photos_count
    self.photos.size
  end
  
  def venues_count
    self.venues.size
  end
  
  def syncs_count
    self.syncs.size
  end  
  
  def followings_count
    self.followings.size
  end  
  
  def influence_count
    [self.callings.map{|c| c.plans.where(:parent_id => nil)},self.plans.map{|p| p.children}].flatten.uniq.size
  end
  
  def douban_count
    self.douban? ? 1 : 0
  end
  
  def sina_count
    self.sina? ? 1 : 0
  end
  
  def realtime_plans_count
    self.plans.count
  end
  
  def realtime_callings_count
    self.callings.count
  end
  
  def is_following?(followable)
    !self.followings.where(:followable_id => followable.id,:followable_type => followable.class).limit(1).blank?
  end

  def user_followings
    self.followings.where(:followable_type => 'User')
  end

  def venue_followings
    self.followings.where(:followable_type => 'Venue')
  end
  
  def calling_followings
    self.followings.where(:followable_type => 'Calling')
  end

  
  #need refactory. use dynamic methods
  
  def has_unread_record_comment?
    self.records.where(:has_new_comment => true).first.present?
  end
  
  def has_unread_calling_comment?
    self.callings.where(:has_new_comment => true).first.present?
  end
  
  def has_unread_comment_comment?
    self.comments.where(:has_new_comment => true).first.present?
  end
  
  def has_unread_topic_comment?
    self.topics.where(:has_new_comment => true).first.present?
  end
  
  def has_unread_saying_comment?
    self.sayings.where(:has_new_comment => true).first.present?
  end
    
  def has_unread_photo_comment?
    self.photos.where(:has_new_comment => true).first.present?
  end
      
  def has_unread_comment?
    has_unread_comment_comment? || has_unread_saying_comment? || has_unread_photo_comment? || has_unread_comment_comment? || has_unread_record_comment? || has_unread_topic_comment? || has_unread_calling_comment?
  end
  
  def has_unread_plan?
    self.callings.where(:has_new_plan => true).first.present?
  end
  
  def has_unread_child?
    self.plans.where(:has_new_child => true).first.present?
  end
  
  def has_new_badge?
    self.grants.where(:unread => true).first.present?
  end
  
  def has_unread_follower?
    self.follows.where(:unread => true).first.present?
  end
    
  def latest_update
    [self.records.first,self.callings.first,self.plans.first].compact.sort{|x,y| y.created_at <=> x.created_at }.first
  end
  
  # Use OAuth::AccessToken to access oauth api. powered by oauth_side 
  def send_to_douban_miniblog(message)
    content = "<?xml version='1.0' encoding='UTF-8'?><entry xmlns:ns0='http://www.w3.org/2005/Atom' xmlns:db='http://www.douban.com/xmlns/'><content>#{message}</content></entry>"
    self.douban.post('http://api.douban.com/miniblog/bubble',content, {"Content-Type" =>  "application/atom+xml"}  )
  end
  
  def send_to_sina_miniblog(message)
    self.sina.post('http://api.t.sina.com.cn/statuses/update.xml',{:status => message}, {"Content-Type" =>  "application/atom+xml"}  )
  end

  def send_to_miniblogs(message,options={})
    self.send_to_douban_miniblog(message) if (options[:to_douban] && douban?)
    self.send_to_sina_miniblog(message) if (options[:to_sina] && sina?)
  end
  
  def check_badge_condition_on(*args)
    args.each do |condition_factor|
      Badge.where(:condition_factor => condition_factor).each do |badge|
        if (self.method("#{badge.condition_factor}").call >= badge.condition_number)
          self.grants.build(:badge_id => badge.id).save
        end
      end
    end
  end
  
  def generate_password(length)
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
    password = ''
    length.times do |i|
      password << chars[rand(62)]
    end
    password
  end
  
  def reset_password!
    self.password = self.password_confirmation = generate_password(6)
    self.encrypt_password
    self.password = nil
    Mailer.reset_password(self,self.password_confirmation).deliver if self.save
  end
    
  define_index do
    indexes login
    indexes geo.name,:as => :city
    
    has geo_id
  end

  protected
  
end
