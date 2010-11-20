class SyncObserver < ActiveRecord::Observer
  def after_create(sync)
    sync.user.send_to_miniblogs( sync.content,
                                :to_douban => (sync.douban && sync.user.douban?),
                                :to_sina => (sync.sina && sync.user.sina?)
                                )
    sync.user.check_badge_condition_on('syncs_count')
  end
end
