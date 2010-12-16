class Calling < ActiveRecord::Base
  belongs_to :user,     :counter_cache => true
  belongs_to :venue
  belongs_to :action
  has_many   :records
  has_many   :plans
  has_many   :comments, :as => :commentable, :dependent => :destroy
  has_many   :syncs,    :as => :syncable,    :dependent => :destroy
  has_many   :photos,   :as => :imageable,   :dependent => :destroy
  has_many   :follows,  :as => :followable,  :dependent => :destroy
  has_many   :followers,:through => :follows,:source => :user
  
  default_scope :order => 'created_at DESC'
  
  scope :not_closed,where(:close => false) 
  scope :timing,where(:action_id => [1]) # timeing action list 
  
  delegate :for_what, :to => :action
  
  validates :detail,:length => {:within => 50..1000 ,:message => '详细信息不能少于50字'}
  validates :user_id,:action_id,:venue_id,:info,:presence   => true
  validates :do_at,:date => {:after_or_equal_to => Date.today.to_date,:allow_nil => true,:on => :create}
  
  def validate
    errors["total_#{for_what}"] << '数量必须为大于0的整数' unless total_number && (total_number > 0)
    errors[({'time' => :do_what,'money' => :donate_for,'goods' => :goods_is}[for_what])] = '请将记录信息填写完整' if content.blank?
    errors[:unit] = '请填写物资单位' if (for_what == 'goods') && unit.blank?
    errors[:do_at] = '请填写集合日期' if (for_what == 'time') && do_at.blank?
  end
  
  def content
    {'time' => do_what,'money' => donate_for,'goods' => goods_is}[for_what]
  end
    
  def users_count
    self.plans.map(&:user).uniq.size
  end
  
  def total_number_tag
    {'money' => "#{total_money}元",'goods' => "#{total_goods}#{unit}",'time' => "#{total_people}人" }[for_what]
  end
  
  def total_number
    {'money' => total_money ,'goods' => total_goods,'time' => total_people }[for_what]
  end
  
  def remaining_number
    if for_what == 'time'
      (self.total_number > self.plans.size) ?  (self.total_number - self.plans.size) : 0
    else
      (self.total_number > self.plans.map(&(for_what.to_sym)).sum) ? (self.total_number - self.plans.map(&(for_what.to_sym)).sum) : 0
    end
  end
  
  def complete_number
    if for_what == 'time'
      self.plans.size
    else
      self.records.present? ? self.records.map(&(for_what.to_sym)).sum : 0
    end
  end
  
  def status
    if self.users_count.zero?
      '还没有人参与'
    else
      if for_what == 'money'
        "已有#{self.users_count}人要捐赠#{self.plans.map(&:money).sum}元"
      elsif for_what == 'goods'
        "已有#{self.users_count}人要捐赠#{self.plans.map(&:goods).sum}#{self.unit}"
      elsif for_what == 'time'
        "已有#{self.users_count}人要参加"
      end  
    end
  end
   
  def percentage
    if for_what == 'money'
      (self.records.map(&:money).sum*100 / self.total_money)
    elsif for_what == 'time'
      (self.plans.map(&:user).size*100 / self.total_people)
    elsif for_what == 'goods'
      (self.records.map(&:goods).sum*100 / self.total_goods)
    end
  end
  
  def formatted_do_at
    date = self.do_at
    "#{date.year == Date.today.year ? '' : "#{date.year}年"}#{date.month}月#{date.day}日"
  end
  
  def description
    if self.action.for_what == 'money'
      "为#{self.venue.name}募捐#{self.total_money}元用于#{self.donate_for}"
    elsif self.action.for_what == 'goods'
      "为#{self.venue.name}募捐#{self.total_goods}#{self.unit}#{self.goods_is}"
    elsif self.action.for_what == 'time'
      "召集#{self.total_people}人去#{self.venue.name}#{self.do_what},时间：#{self.formatted_do_at}"
    end
  end
  
  def name
    if self.action.for_what == 'money'
      "#{self.user.login}为#{self.venue.name}募捐"
    elsif self.action.for_what == 'goods'
      "#{self.user.login}为#{self.venue.name}募捐#{self.goods_is}"
    elsif self.action.for_what == 'time'
      "#{self.user.login}为#{self.venue.name}召集人#{self.do_what}"
    end
  end
  
  def can_edit_by?(current_user)
    self.user == current_user
  end
      
  define_index do
    indexes do_what
    indexes goods_is
    indexes detail
    indexes info
    indexes venue.name ,:as => :venue
    indexes venue.geo.name ,:as => :city
    has venue_id
  end
  
end
