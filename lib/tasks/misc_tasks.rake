namespace :misc do
  desc "User polymorphic association topic and venue"
  task :polymorphic_topic => :environment do
    Topic.all.each do |t|
      t.update_attributes(:forumable_type => 'Venue',:forumable_id => t.venue_id) if t.venue_id
    end
  end 
  
  desc "Turned description into title for calling"
  task :create_calling_title => :environment do
    Calling.where(:title => nil).each do |c|
      c.update_attributes(:title => c.do_what || "捐赠#{c.goods_is}" )
    end
  end
  
  desc "Create last bumped stamp to sort callings"
  task :stamp_calling_last_bumped => :environment do
    Calling.all.each do |c|
      c.update_attributes(:last_bumped_at => [(c.plans.map(&:created_at)[0] || c.created_at) ,(c.records.map(&:created_at)[0]|| c.created_at)].max)
      case c.last_bumped_at
      when c.plans.map(&:created_at)[0]
        c.update_attributes(:last_bumped_type => 'plan')
      when c.records.map(&:created_at)[0]
        c.update_attributes(:last_bumped_type => 'record')
      end
    end
  end
end
