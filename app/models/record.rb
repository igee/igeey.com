class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :action
  belongs_to :calling
  belongs_to :plan
  belongs_to :parent,   :class_name => :record,:foreign_key => :parent_id
  has_many   :comments, :as => :commentable,    :dependent => :destroy
  has_many   :photos,   :as => :imageable,      :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  delegate :for_what, :to => :action
  
  validates :user_id,:action_id,:venue_id,:presence   => true
  validates :done_at,:date => {:before_or_equal_to => Date.today.to_date}
  
  def validate
    if (money.present? && donate_for.present? && (for_what == 'money')) || \
       (goods.present? && goods_is.present? && for_what == 'goods') || \
       (time.present? && do_what.present? && for_what == 'time')
      
      errors[for_what] << '数量必须为大于0的整数' unless number > 0
    else
      errors[:info] << '请将时记录信息填写完整' 
    end
    if plan.present? && plan.is_done
      errors[:info] <<  '你已经完成了这个计划' 
    end
  end
  
  def number
    {'money'=> money,'goods'=> goods,'time'=> time}[for_what]
  end
    
  def info
    {'money'=> donate_for,'goods'=> goods_is,'time'=> do_whats}[for_what]
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
    
  def formatted_done_at
    date = self.done_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    result = "在#{self.formatted_done_at}"
    if self.action.for_what == 'money'
      result << "捐款#{self.money}元到#{self.venue.name}，用于#{self.donate_for}。"
    elsif self.action.for_what == 'goods'
      result << "捐赠#{self.goods}件#{self.goods_is}给#{self.venue.name}。"
    elsif self.action.for_what == 'time'
      result << "去#{self.venue.name}做了#{self.time}小时的#{self.do_what}。"
    end
  end
  
end
