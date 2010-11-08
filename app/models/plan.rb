class Plan < ActiveRecord::Base
  belongs_to :venue
  belongs_to :action
  belongs_to :calling
  belongs_to :user
  belongs_to :parent,:class_name => :plan,:foreign_key => :parent_id
  has_one    :record
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :plans
  has_many   :children, :class_name => :plan ,:foreign_key => :parent_id
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  delegate :for_what, :to => :action
  
  default_scope :order => 'created_at DESC'
  
  scope :undone ,where(:is_done => false)
  
  validates :user_id,:action_id,:calling_id,:venue_id,:presence => true
  validates :plan_at,:date => {:after_or_equal_to => Date.today.to_date,:allow_nil => true}
  
  def validate
    errors[:number] = '数量必须为大于0的整数' unless ((money.to_i > 0) && for_what == 'money') || ((goods.to_i > 0) && for_what == 'goods') || (for_what == 'time')
    errors[:plan_at] = '请填写你计划日期' if (for_what == 'time') && plan_at.nil?
  end
  
  def formatted_plan_at
    date = self.plan_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    if self.action.for_what == 'money'
      "为#{self.venue.name}#{self.action.name}#{self.money}元，用于#{self.calling.donate_for}。"
    elsif self.action.for_what == 'goods'
      "为#{self.venue.name}#{self.action.name}#{self.calling.goods_is}#{self.goods}件。"
    elsif self.action.for_what == 'time'
      "在#{self.formatted_plan_at}为#{self.venue.name}#{self.action.name}:#{self.calling.do_what}。"
    end
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
  
end

