namespace :misc do
  
  desc "User polymorphic association topic and venue"
  task :polymorphic_topic => :environment do
    Topic.all.each do |t|
      t.update_attributes(:forumable_type => 'Venue',:forumable_id => t.venue_id) if t.venue_id
    end
  end 
  
end
