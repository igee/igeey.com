class Requirement < ActiveRecord::Base
  belongs_to :publisher, :class_name => "User", :foreign_key => :publisher_id
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  validates :detail,:length => { :within => 50..1000 ,:message => '详细信息要不能少于50字'}
  validates :publisher_id,:action_id,:venue_id,:presence   => true

  def validate
    if (total_money && donate_for) || (total_goods && goods_is) || (total_people && do_what)
      errors[:number] << '数量必须为大于0的整数' unless (total_money.to_i > 0)||(total_goods.to_i > 0)||(total_people.to_i > 0)
    else
      errors[:info] << '请将需求信息填写完整' 
    end
  end
    
  def users_count
    self.plans.map(&:user).uniq.size
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
      "#{self.venue.name}需要#{self.total_money}元用于#{self.donate_for}。"
    elsif self.action.for_what == 'goods'
      "#{self.venue.name}需要#{self.total_goods}件#{self.goods_is}。"
    elsif self.action.for_what == 'time'
      "#{self.venue.name}需要#{self.total_people}人#{self.do_what}。"
    end
  end
   
  def can_edit_by?(current_user)
    self.publisher == current_user
  end
  
end
