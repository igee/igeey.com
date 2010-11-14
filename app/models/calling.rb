class Calling < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => :user_id
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  delegate :for_what, :to => :action
  
  validates :detail,:length => {:within => 50..1000 ,:message => '详细信息要不能少于50字'}
  validates :user_id,:action_id,:venue_id,:presence   => true

  def validate
    errors["total_#{for_what}"] << '数量必须为大于0的整数' unless total_number > 0
    errors[(content.blank? ? {'time' => :do_what,'money' => :donate_for,'goods' => :goods_is}[for_what] : "total_#{for_what}")] = '请将记录信息填写完整' 
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
  
  def finished_status
    {'money' => "已获捐#{self.records.map(&:money).sum}元",'goods' => "已获捐#{self.records.map(&:goods).sum}件",'time' => "已有#{self.plans.map(&:user).uniq.size}人参加"}[for_what]
  end
   
  def percentage
    if self.action.for_what == 'money'
      (self.records.map(&:money).sum*100 / self.total_money)
    elsif self.action.for_what == 'time'
      (self.plans.map(&:user).uniq.size*100 / self.total_people)
    elsif self.action.for_what == 'goods'
      (self.records.map(&:goods).sum*100 / self.total_goods)
    end
  end
  
  def description
    if self.action.for_what == 'money'
      "在为#{self.venue.name}募捐#{self.total_money}元用于#{self.donate_for}。"
    elsif self.action.for_what == 'goods'
      "在为#{self.venue.name}募捐物资#{self.total_goods}件#{self.goods_is}。"
    elsif self.action.for_what == 'time'
      "在为#{self.venue.name}召集#{self.total_people}人去#{self.do_what}。"
    end
  end
   
  def can_edit_by?(current_user)
    self.user == current_user
  end
  
end
