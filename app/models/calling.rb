class Calling < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :syncs,    :as => :syncable,    :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  has_many   :follows,  :as => :followable,  :dependent => :destroy
  has_many   :followers,:through => :follows,:source => :user
  
  default_scope :order => 'created_at DESC'
  
  scope :not_closed,where(:close => false) 
  scope :timing,where(:action_id => [1]) # timeing action list 
  
  delegate :for_what, :to => :action
  
  validates :detail,:length => {:within => 50..1000 ,:message => '详细信息需要在50字-1000字之间'}
  validates :user_id,:action_id,:venue_id,:title,:address,:contact,  :presence => true
  validates :do_at,:date => {:after_or_equal_to => 1.day.ago ,:allow_nil => true,:on => :create}
  
  def validate
    errors["total_#{for_what == 'time' ? 'people' : for_what }"] << '数量必须为大于0的整数' unless total_number && (total_number > 0)
    errors[:do_at] = '请填写集合日期' if (for_what == 'time') && do_at.blank?
  end
    
  def users_count
    self.plans.map(&:user).uniq.size
  end
  
  def total_number_tag
    {'money' => "#{total_money}元",'goods' => "#{total_goods}",'time' => "#{total_people}人" }[for_what]
  end
  
  def total_number
    {'money' => total_money ,'goods' => total_goods,'time' => total_people }[for_what]
  end
  
  def remaining_number
    if for_what == 'time'
      (self.total_number > self.plans.size) ?  (self.total_number - self.plans.size) : 0
    else
      (self.total_number > self.plans.map(&(for_what.to_sym)).sum) ? (self.total_number - self.plans.map(&(for_what.to_sym)).sum) : 0
    end
  end
  
  def complete_number
    if for_what == 'time'
      self.plans.size
    else
      self.records.present? ? self.records.map(&(for_what.to_sym)).sum : 0
    end
  end
  
  def status
    if for_what == 'money'
      "共需#{self.total_number}元,已捐#{self.plans.map(&:money).sum}元"
    elsif for_what == 'goods'
      "共需#{self.total_number}件,已捐#{self.plans.map(&:goods).sum}件"
    elsif for_what == 'time'
      "共需#{self.total_number}人,已报名#{self.users_count}人"
    end
  end
   
  def percentage
    if for_what == 'money'
      (self.records.map(&:money).sum*100 / self.total_money)
    elsif for_what == 'time'
      (self.plans.map(&:user).size*100 / self.total_people)
    elsif for_what == 'goods'
      (self.records.map(&:goods).sum*100 / self.total_goods)
    end
  end
  
  def formatted_do_at
    date = self.do_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    "为#{self.venue.name}发起行动：#{self.title}"
  end
  
  def stamped_at
    last_bumped_at
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
      
  define_index do
    indexes title
    indexes detail
    indexes address
    indexes contact
    indexes venue.name ,:as => :venue
    indexes venue.geo.name ,:as => :city
    has venue_id
  end
  
end
