class ActionObserver < ActiveRecord::Observer
  def before_create(action)
    tag = Tag.where(:name=>action.name).first || Tag.create(:name=>action.name)
    action.tag_id = tag.id
  end
end
