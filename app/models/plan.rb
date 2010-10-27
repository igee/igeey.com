class Plan < ActiveRecord::Base
  belongs_to :venue
  belongs_to :action
  belongs_to :requirement
  belongs_to :user
  belongs_to :parent,:class_name => "Plan",:foreign_key => "parent_id"
  has_one    :record
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :plans
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  delegate :for_what, :to => :action
  
  validates :user_id,:action_id,:requirement_id,:venue_id,:presence   => true
  validates :plan_at,:date => {:after_or_equal_to => Date.today.to_date}
  
  def validate
    errors[:number] = '数量必须为大于0的整数' unless ((money.to_i > 0) && for_what=='money')||((goods.to_i > 0) && for_what='goods') 
  end
  
  default_scope :order => 'created_at DESC'
  
  def formatted_plan_at
    date = self.plan_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    if self.action.for_what == 'money'
      "为#{self.venue.name}#{self.action.name}#{self.money}元，用于#{self.requirement.donate_for}。"
    elsif self.action.for_what == 'goods'
      "为#{self.venue.name}#{self.action.name}#{self.requirement.goods_is}#{self.goods}件。"
    elsif self.action.for_what == 'time'
      "在#{self.formatted_plan_at}为#{self.venue.name}#{self.action.name}:#{self.requirement.do_what}。"
    end
  end
  
  def can_edit_by?(current_user)
    true if self.user = current_user
  end
  
end

