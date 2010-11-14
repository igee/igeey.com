class Plan < ActiveRecord::Base
  belongs_to :venue
  belongs_to :action
  belongs_to :calling
  belongs_to :user
  belongs_to :parent,:class_name => :plan,:foreign_key => :parent_id
  has_one    :record
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :plans
  has_many   :children, :class_name => 'Plan' ,:foreign_key => :parent_id
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  delegate :for_what, :to => :action
  
  default_scope :order => 'created_at DESC'
  
  scope :undone ,where(:is_done => false)
  
  validates :user_id,:action_id,:calling_id,:venue_id,:presence => true
  validates :plan_at,:date => {:after_or_equal_to => Date.today.to_date,:allow_nil => true}
  
  def validate
    errors[for_what] = '数量必须为大于0的整数' unless number > 0
    errors[:plan_at] = '请填写你计划日期' if (for_what == 'time') && plan_at.nil?
  end
  
  def number
    {'money'=> money,'goods'=> goods,'time'=> 1}[for_what] || 0
  end
  
  def formatted_plan_at
    date = self.plan_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    if self.action.for_what == 'money'
      "要为#{self.venue.name}捐款#{self.money}元，用于#{self.calling.donate_for}。"
    elsif self.action.for_what == 'goods'
      "要为#{self.venue.name}捐赠#{self.calling.goods_is}#{self.goods}件。"
    elsif self.action.for_what == 'time'
      "要在#{self.formatted_plan_at}去#{self.venue.name}#{self.action.name}:#{self.calling.do_what}。"
    end
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
end