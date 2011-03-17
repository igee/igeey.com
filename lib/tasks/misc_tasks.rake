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
      c.title = (c.do_what || "捐赠#{c.goods_is}" )
      c.save(false)
    end
  end
  
  desc "Turn description into title for record"
  task :create_record_title => :environment do
    Record.where(:title => nil).each do |r|
      r.title = (r.do_what || "捐赠#{r.goods_is}")
      c.save(flase)
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
  
  desc "Create last replied stamp to models"
  task :stamp_last_replied => :environment do
    [Record,Calling,Photo,Saying,Topic].each do |model|
      model.all.each do |item|
        item.last_replied_at = (item.comments.empty? ? item.created_at : item.comments.last.created_at )
        item.last_replied_user_id = (item.comments.empty? ? nil : item.comments.last.user_id )
        item.save(false)
      end
    end
  end
  
  desc "Create square thumbnails for venue"
  task :square_venue_cover => :environment do
    require 'RMagick'
    dir = Dir.new("#{Rails.root}/public/media/covers/venues")
    path = "#{dir.path}"
    extension = 'jpg'
    (dir.map() - ["..","."]).each do |id|
      filename = Dir.new("#{dir.path}/#{id}").map{|f| f if f =~ /^original\..*/}
      clown = Magick::Image.read("#{dir.path}/#{id}/#{filename}").first
      clown.crop_resized!(100, 100, Magick::NorthGravity)
      clown.write("#{dir.path}/#{id}/_100x100.#{extension}")
      clown.crop_resized!(48, 48, Magick::NorthGravity)
      clown.write("#{dir.path}/#{id}/_48x48.#{extension}")
    end
  end
  
  desc "Create venue_id for photo"
  task :photo_venue_id => :environment do
    Photo.all.each do |p|
      p.update_attributes(:venue_id => (p.imageable_type == 'Venue' ? p.imageable.id : p.imageable.venue.id))
    end
  end
  
  desc "Init comments_count for models"
  task :init_comments_count => :environment do
    [Record,Calling,Photo,Saying,Topic].each do |model|
      model.all.each do |item|
        item.update_attribute(:comments_count,item.comments.size)
      end
    end
  end
  
  desc "Import 1kg schools data as venues"
  task :import_1kg_schools => :environment do
    puts("start at id:#{Venue.first.id + 1 }")
    YAML.load(open('1kg_schools.yaml')).each do |s|
      v = Venue.new(s)
      if Venue.where(:name => v.name).empty?
        v.creator_id = 1
        v.category = 8
        v.save(false)
      end      
    end
    puts("end at id:#{Venue.first.id}")
  end
  
  desc "Import university data as venues"
  task :import_university => :environment do
    p("start at id:#{Venue.first.id + 1 }")
    File.open('university.txt').readlines.each do |s|
      v = Venue.new(eval(s))
      if Venue.where(:name => v.name).empty?
        v.creator_id = 1
        v.category = 4
        v.geo_id = 1
        v.save(false)
      end  
    end
    puts("end at id:#{Venue.first.id}")
  end
end
