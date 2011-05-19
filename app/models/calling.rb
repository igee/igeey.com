class Calling < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue,    :counter_cache => true
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :syncs,    :as => :syncable,    :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  has_many   :follows,  :as => :followable,  :dependent => :destroy
  has_many   :votes,    :as => :voteable,    :dependent => :destroy
  has_many   :followers,:through => :follows,:source => :user
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  
  acts_as_ownable
  acts_as_taggable
  acts_as_eventable  
  
  default_scope :order => 'created_at DESC'
  
  scope :not_closed,where(:close => false) 
  
  validates :detail,:length => {:minimum => 1 ,:message => '详细信息不能少于50字'}
  validates :user_id,:venue_id,:title,:address,:contact,  :presence => true
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
    "为#{self.venue.name}发起行动：#{self.title}，请大家踊跃报名！"
  end
  
  def self.tag_list
    Tagging.where(:taggable_type => self.to_s).limit(5)
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
