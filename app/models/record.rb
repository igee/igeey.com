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
    
  def formatted_do_at
    date = self.do_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    result = "在#{self.formatted_do_at}为#{self.venue.name}#{self.action.name}"
    if self.action.for_what == 'money'
      result << "#{self.money}元，用于#{self.donate_for}。"
    elsif self.action.for_what == 'goods'
      result << "#{self.goods}件#{self.goods_is}。"
    elsif self.action.for_what == 'time'
      result << "#{self.time}小时，#{self.do_what}。"
    end
  end
  
end
