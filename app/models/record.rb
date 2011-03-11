class Record < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue,    :counter_cache => true
  belongs_to :action
  belongs_to :calling
  belongs_to :plan
  belongs_to :project
  belongs_to :parent,   :class_name => :record,:foreign_key => :parent_id
  has_many   :comments, :as => :commentable,    :dependent => :destroy
  has_many   :follows,  :as => :followable,     :dependent => :destroy
  has_many   :syncs,    :as => :syncable,       :dependent => :destroy
  has_many   :photos,   :as => :imageable,     :dependent => :destroy
  
  default_scope :order => 'created_at DESC'
  scope :markers,where(:action_id => 4)
  
  delegate  :for_what, :to => :action
  
  acts_as_taggable
  
  accepts_nested_attributes_for :photos
  
  validate  :user_id, :presence  => true,:uniqueness => {:scope => [:plan_id]}
  validates :action_id,:venue_id,:title,:presence  => true
  validates :done_at,:date => {:before_or_equal_to => Date.today.to_date}
  
  def validate
    errors[for_what] << '数量必须为大于0的整数' unless number > 0
  end
  
  def content
    {'time' => do_what,'money' => donate_for,'goods' => goods_is,'online' => title }[for_what]
  end
  
  def number
    {'money'=> money,'goods'=> goods,'time'=> time,'online' => online}[for_what] || 0
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
    
  def formatted_done_at
    date = self.done_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end

  def description
    "完成了在#{self.venue.name}的行动：#{self.title}"
  end
  
  def is_done
    true
  end
  
  def name
    if self.action.slug == 'volunteer_service'
      "#{self.user.login}去#{self.venue.name}#{self.do_what}"
    elsif self.action.slug == 'goods_donation'
      "#{self.user.login}为#{self.venue.name}捐赠#{self.goods_is}"
    elsif self.action.slug == 'mark_map' 
      "#{self.user.login}为#{self.venue.name}标记地图"
    elsif self.action.slug == 'money_donation'
      "#{self.user.login}为#{self.venue.name}捐款"
    end
  end
    
end
