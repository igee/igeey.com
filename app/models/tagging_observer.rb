class SyncObserver < ActiveRecord::Observer
  def before_create(tagging)
    tagging.tagger = tagging.taggable.user
  end
end
