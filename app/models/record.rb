class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  belongs_to :action
  belongs_to :requirement
  belongs_to :plan
  belongs_to :parent,   :class_name => "Record",:foreign_key => "parent_id"
  has_many   :comments, :as => :commentable,    :dependent => :destroy
  has_many   :photos,   :as => :imageable,      :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  
  attr_accessor :sync_to_sina,:sync_to_douban,:sync_to_renren
  
  delegate :for_what, :to => :action
  
  validates :user_id,:action_id,:venue_id,:presence   => true
  validates :done_at,:date => {:before_or_equal_to => Date.today.to_date}
  
  def validate
    if (money && donate_for && (for_what == 'money')) || (goods && goods_is && for_what == 'goods') || (time && do_what && for_what == 'time')
      errors[:number] << '数量必须为大于0的整数' unless number > 0
    else
      errors[:info] << '请将需求信息填写完整' 
    end
  end
  
  def number
    {'money'=> money,'goods'=> goods,'time'=> time}[for_what]
  end
    
  def info
    {'money'=> donate_for,'goods'=> goods_is,'time'=> do_whats}[for_what]
  end  
    
  def formatted_done_at
    date = self.done_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    result = "在#{self.formatted_done_at}为#{self.venue.name}#{self.action.name}"
    if self.action.for_what == 'money'
      result << "#{self.money}元，用于#{self.donate_for}。"
    elsif self.action.for_what == 'goods'
      result << "#{self.goods}件#{self.goods_is}。"
    elsif self.action.for_what == 'time'
      result << "#{self.time}小时，#{self.do_what}。"
    end
  end
  
end
