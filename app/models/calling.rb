class Calling < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  has_many   :follows,  :as => :followable,  :dependent => :destroy
  has_many   :followers,:through => :follows,:source => :user
  default_scope :order => 'created_at DESC'
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  delegate :for_what, :to => :action
  
  validates :detail,:length => {:within => 50..1000 ,:message => '详细信息要不能少于50字'}
  validates :user_id,:action_id,:venue_id,:presence   => true

  def validate
    errors["total_#{for_what}"] << '数量必须为大于0的整数' unless total_number > 0
    errors[({'time' => :do_what,'money' => :donate_for,'goods' => :goods_is}[for_what])] = '请将记录信息填写完整' if content.blank?
  end
  
  def content
    {'time' => do_what,'money' => donate_for,'goods' => goods_is}[for_what]
  end
    
  def users_count
    self.plans.map(&:user).uniq.size
  end
  
  def total_number
    {'money' => total_money,'goods' => total_goods,'time' => total_people }[for_what] || 0
  end
  
  def remaining_number
    if for_what == 'time'
      self.total_number - self.plans.size
    else
      self.total_number - self.plans.map(&(for_what.to_sym)).sum
    end
  end
  
  def status
    if self.users_count.zero?
      '还没有人参与'
    else
      if for_what == 'money'
        "已有#{self.users_count}人要捐增#{self.plans.map(&:money).sum}元"
      elsif for_what == 'goods'
        "已有#{self.users_count}人要捐增#{self.plans.map(&:goods).sum}件"
      elsif for_what == 'time'
        "已有#{self.users_count}人要参加"
      end  
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
  
  def description
    if self.action.for_what == 'money'
      "在为#{self.venue.name}募捐#{self.total_money}元用于#{self.donate_for}。"
    elsif self.action.for_what == 'goods'
      "在为#{self.venue.name}募捐#{self.total_goods}件#{self.goods_is}。"
    elsif self.action.for_what == 'time'
      "在为#{self.venue.name}召集#{self.total_people}人去#{self.do_what}。"
    end
  end
   
  def can_edit_by?(current_user)
    self.user == current_user
  end
  
end
