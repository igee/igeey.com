  class Tagging < ::ActiveRecord::Base #:nodoc:
    attr_accessible :tag,
                    :tag_id,
                    :taggable,
                    :taggable_type,
                    :taggable_id,
                    :user_id,
                    :user

    belongs_to :tag, :counter_cache => true
    belongs_to :taggable, :polymorphic => true
    belongs_to :user

    validates_presence_of :tag_id

    validates_uniqueness_of :tag_id, :scope => [:taggable_type, :taggable_id]
  end
