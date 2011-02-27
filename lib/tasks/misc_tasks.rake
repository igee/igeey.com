namespace :misc do
  desc "User polymorphic association topic and venue"
  task :polymorphic_topic => :environment do
    Topic.all.each do |t|
      t.update_attributes(:forumable_type => 'Venue',:forumable_id => t.venue_id) if t.venue_id
    end
  end 
  
  desc "Turn description into title for calling"
  task :create_calling_title => :environment do
    Calling.where(:title => nil).each do |c|
      c.update_attributes(:title => c.do_what || "捐赠#{c.goods_is}" )
    end
  end
  
  desc "Turn description into title for record"
  task :create_record_title => :environment do
    Record.where(:title => nil).each do |r|
      r.update_attributes(:title => (r.do_what || "捐赠#{r.goods_is}") )
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
  
  desc "Create square thumbnails for venue"
  task :square_venue_cover => :environment do
    require 'RMagick'
    dir = Dir.new("#{Rails.root}/public/media/covers/venues")
    path = "#{dir.path}"
    dir.map()[0..-3].each do |f|
      clown = Magick::Image.read("#{dir.path}/#{f}/original.jpg").first
      clown.crop_resized!(128, 128, Magick::NorthGravity)
      clown.write("#{dir.path}/#{f}/_128x128.jpg")
      clown.crop_resized!(48, 48, Magick::NorthGravity)
      clown.write("#{dir.path}/#{f}/_48x48.jpg")
    end
  end 
end
