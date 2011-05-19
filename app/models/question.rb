class Question < ActiveRecord::Base
  belongs_to :user
  has_many   :answers,       :dependent => :destroy
  has_many   :notifications, :as => :notifiable, :dependent => :destroy
  has_many   :syncs,         :as => :syncable,   :dependent => :destroy
  
  acts_as_taggable
  acts_as_ownable
  
  default_scope :order => 'created_at desc'
  
  validates :title,:length => {:minimum => 1 ,:message => '问题要有起码的字数吧？'}
  validates :user_id,:title,:presence => true
  
  def venue_id
    nil
  end
  
  def validate
    errors[:tag_list] = '请至少填写一个标签' if self.tag_list.empty?
  end
  
  def related_questions
    @questions = []
    self.tags.each do |tag|
      @questions += tag.taggeds.where(['taggable_type=?','Question']).limit(10).map(&:taggable)
    end
    (@questions - [self]).uniq.shuffle
  end
  
  def description
    "在爱聚网提出了一个问题：#{self.title} 请大家帮忙解决！"
  end

end
