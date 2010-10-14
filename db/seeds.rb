# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.new(:login => 'admin',:email => 'admin@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '安猪',:email => 'a@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '敏感词',:email => 'b@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '奥特曼',:email => 'c@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '草泥马',:email => 'd@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '小白',:email => 'e@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '小灰',:email => 'f@igee.org',:password => "password",:password_confirmation => "password").save
User.new(:login => '小黑',:email => 'g@igee.org',:password => "password",:password_confirmation => "password").save

Geo.new(:name => '北京',:latitude => '39.9046670',:longitude => '116.4081980',:zoom_level => 9).save
Geo.new(:name => '天津',:latitude => '39.1208760',:longitude => '117.2150300',:zoom_level => 9).save
Geo.new(:name => '上海',:latitude => '31.2307080',:longitude => '121.4729160',:zoom_level => 9).save
Geo.new(:name => '广州',:latitude => '23.1290750',:longitude => '113.2644230',:zoom_level => 9).save
Geo.new(:name => '成都',:latitude => '30.6586020',:longitude => '104.0648570',:zoom_level => 9).save
Geo.new(:name => '重庆',:latitude => '29.5626860',:longitude => '106.5512340',:zoom_level => 9).save

Venue.new(:name => '太阳村',:geo_id => 1,:category => '1',:creator_id => 1,:latitude => "40.21106465394306",:longitude => "116.53745901684572",:intro => "张淑琴女士于1996年创办的以无偿抚养服刑人员未成年子女为目标的非营利性慈善机构。").save
Venue.new(:name => '某流浪狗收容站',:geo_id => 1,:category => '3',:creator_id => 1,:latitude => "39.91612252026889",:longitude => "116.49694693188478",:intro => "社区里的流浪狗收容站，有20多只流浪狗在这里生活。").save

Action.new(:name => '志愿服务',:for_time => true).save
Action.new(:name => '捐款',:for_amount => true).save
Action.new(:name => '捐物',:for_goods => true).save
