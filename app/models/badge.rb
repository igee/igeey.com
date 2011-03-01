class Badge < ActiveRecord::Base
  
  CONDITIONS_HASH = {'realtime_plans_count' => '参与行动次数',
                     'realtime_callings_count' => '召集行动次数',
                     'douban_count' => '连接豆瓣',
                     'sina_count' => '连接新浪',
                     'venues_count' => '添加地点数',
                     'photos_count' => '上传照片数',
                     'syncs_count'=> '同步次数',
                     'followings_count'=> '关注次数',
                    }
  
  has_many :grants
  has_many :owners,:through => :grant,:class_name => 'User'  
  has_attached_file :cover, :styles => {:_120x120 => ["120x120#"],:_56x56 => ["56x56#"]},
                            :url=>"/media/:attachment/badges/:id/:style.:extension",
                            :default_style=> :_56x56,
                            :default_url=>"/defaults/:attachment/badge/:style.png"
  
  validates :cover_file_name,:format => { :with => /([\w-]+\.(gif|png|jpg))|/ }
  
  def grant_to?(user)
    user.grants.where(:badge_id => self.id).present?
  end
end
