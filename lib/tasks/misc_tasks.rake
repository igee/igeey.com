namespace :misc do
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
  
  desc "Update empty 1kg schools intro"
  task :update_1kg_schools_intro => :environment do
    require 'open-uri'
    Venue.where(:category => 8).each do |v|
      if v.intro.blank?
        intro = open("http://www.1kg.org/schools/#{v.old_id}/intro").read
        v.update_attribute(:intro,intro)
        sleep(1)
      end
    end
  end
  
  desc "Init venue_id fot Topic"
  task :topic_venue_id => :environment do
    Topic.where(:forumable_type => "Venue",:venue_id => nil).each do |t|
      t.update_attribute(:venue_id,t.forumable_id)
    end
  end
  
  desc "Update venue geo information"
  task :update_geo_id => :environment do
    require 'open-uri'
    Venue.where(:id=>190..1792).each do |v|
      begin
        print "updating venue id:#{v.id} geo_city"
        r = JSON.parse(open("http://maps.google.com/maps/geo?q=#{URI.escape(v.name)}").read)
        w = r["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"]["LocalityName"]
        g = Geo.find_by_name(w.mb_chars.slice(0..-2).to_s)
        puts "into #{g.nil? ? 'unknow' : g.name} "
        v.update_attribute(:geo_id,(g.nil? ? 0 : g.id ))
        sleep(1)
      rescue
        puts " error."
        v.update_attribute(:geo_id,0)
      end  
    end
  end
end
