class Plan < ActiveRecord::Base
  belongs_to :venue
  belongs_to :action
  belongs_to :calling
  belongs_to :user,     :counter_cache => true
  belongs_to :parent,   :class_name => 'Plan',:foreign_key => :parent_id
  has_one    :record
  has_many   :syncs,    :as => :syncable,    :dependent => :destroy
  has_many   :plans
  has_many   :children, :class_name => 'Plan' ,:foreign_key => :parent_id
  
  delegate :for_what, :to => :action
  
  default_scope :order => 'created_at DESC'
  
  scope :undone ,where(:is_done => false)
  
  validates :action_id,:calling_id,:venue_id,:presence => true
  validates :plan_at,:date => {:after_or_equal_to => 1.day.ago,:allow_nil => true}
  validates :user_id,    :presence   => true,:uniqueness => {:scope => :calling_id}
  
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

  def status
    self.calling.status
  end
  
  def description
    "要参加这个行动：#{self.calling.title}"
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
  
  def name
    if self.action.slug == 'money_donation'
      "#{self.user.login}要为#{self.venue.name}捐款"
    elsif self.action.slug == 'goods_donation'
      "#{self.user.login}要为#{self.venue.name}捐赠#{self.calling.goods_is}"
    elsif self.action.slug == 'volunteer_service'
      "#{self.user.login}要去#{self.venue.name}#{self.calling.do_what}"
    end
  end
  
end