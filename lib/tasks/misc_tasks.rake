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
    
  desc "Update venue geo city"
  task :create_geo_city => :environment do
    p("start at id:#{Venue.unscoped.order("id asc").last.id + 1 }")
    Geo.all.each do |g|
      if Venue.where(:name => g.name).empty?
        v = Venue.new(:name => g.name, :geo_id => g.id, :zoom_level => g.zoom_level, 
                    :latitude => g.latitude, :longitude => g.longitude, :category => '9',
                    :creator_id => 1)
        v.save
      end
    end
    puts("end at id:#{Venue.unscoped.order("id asc").last.id }")
    Follow.where(:user_id=>1).map(&:destroy)
  end
  
  desc "Init Event list"
  task :init_event => :environment do
    timeline = (Saying.all + Calling.all + Photo.all + Topic.all).sort{|x,y| x.created_at <=> y.created_at}
    timeline.each do |item|
      Event.create(:user=>item.user,:eventable => item,:venue => item.venue) if item.event.nil?
      print '.'
    end
  end

  desc "Update OauthToken unique_id"
  task :update_oauth_unique_id => :environment do
    OauthToken.where(:unique_id => nil).each do |o|
      puts o.id
      o.update_attribute(:unique_id, o.get_site_unique_id)
    end
  end
  
  desc "Checking Counters for User and Venue"
  task :check_counters => :environment do
    User.all.each do |u|
      u.update_attributes(:photos_count=>u.photos.count,:sayings_count=>u.sayings.count,:callings_count=>u.callings.count,:sayings_count=>u.sayings.count)
      print(u.save ? '.' : 'x')
    end
    
    Venue.all.each do |v|
      v.update_attributes(:photos_count=>v.photos.count,:sayings_count=>v.sayings.count,:callings_count=>v.callings.count,:sayings_count=>v.sayings.count)
      print(v.save ? '.' : 'x')
    end
  end
  
  desc "Update notifications"
  task :update_notifications => :environment do
    Comment.where(:has_new_comment => true).each do |c|
      print '.' if Notification.new(:user_id=>c.user_id, :notifiable_id=>c.commentable_id, :notifiable_type=>c.commentable_type).save
    end
    photos = Photo.where(:has_new_comment => true)
    sayings = Saying.where(:has_new_comment => true)
    topics = Topic.where(:has_new_comment => true)
    callings = Calling.where(:has_new_comment => true)
    all = photos + sayings + topics + callings
    all.each do |a|
      print '.' if Notification.new(:user_id=>a.user_id, :notifiable_id=>a.id, :notifiable_type=>a.class.to_s).save
    end
    Follow.where(:followable_type=>'User', :unread=>true).each do |f|
      print '.' if Notification.new(:user_id=>f.followable_id, :notifiable_id=>f.user_id, :notifiable_type=>f.followable_type).save
    end
  end
  
  desc "Trans polymorphic form Calling to Task"
  task :calling_to_task => :environment do
    Comment.where(:commentable_type => 'Calling').each do |c|
      c.update_attribute(:commentable_type,'Task')
    end
    Photo.where(:imageable_type => 'Calling').each do |c|
      c.update_attribute(:imageable_type,'Task')
    end
    Sync.where(:syncable_type => 'Calling').each do |c|
      c.update_attribute(:syncable_type,'Task')
    end
    Follow.where(:followable_type => 'Calling').each do |c|
      c.update_attribute(:followable_type,'Task')
    end
    Vote.where(:voteable_type => 'Calling').each do |c|
      c.update_attribute(:voteable_type,'Task')
    end
    Notification.where(:notifiable_type => 'Calling').each do |c|
      c.update_attribute(:notifiable_type,'Task')
    end
    Event.where(:eventable_type => 'Calling').each do |c|
      c.update_attribute(:eventable_type, 'Task')
    end
    Tagging.where(:taggable_type => 'Calling').each do |c|
      c.update_attribute(:taggable_type, 'Task')
    end
  end

  desc "Update Calling for what from Action"
  task :update_callling_for_what_from_action => :environment do
    Calling.all.each do |c|
      print '.' if c.update_attribute(:for_what,c.action.for_what)
    end
  end
  
  desc "Record and plan to plan merger"
  task :record_and_plan_to_plan_merger => :environment do
    Record.all.each do |r|
      r.plan.update_attributes(:result=>r.detail, :done_at=>r.done_at)
      print(r.save ? '.' : 'x')
    end
  end
      
  desc "Send message to everyone"
  task :send_message_to_everyone => :environment do
    content = "站内信功能上线了！\n大家觉得目前站内信功能还有什么不完善的地方可以到 http://www.igeey.com/questions/135 进行交流！"
    User.all.each do |u|
      print '.' if Message.new(:from_user_id => 1, :to_user_id => u.id, :content => content).save
    end
  end
end
