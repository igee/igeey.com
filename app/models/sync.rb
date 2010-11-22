class Sync < ActiveRecord::Base
  belongs_to :syncable, :polymorphic => true
  belongs_to :user
  def validate
    errors['none_to_sync'] = '没有要同步的网站' if sina.blank? && douban.blank?
  end
end
