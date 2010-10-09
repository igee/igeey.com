# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.new(:login => 'admin',
         :email => 'admin@igee.org',
         :password => "password",
         :password_confirmation => "password"
        ).save


Geo.new(:name => '北京',:latitude => '39.9046670',:longitude => '116.4081980',:zoom_level => 9).save
Geo.new(:name => '天津',:latitude => '39.1208760',:longitude => '117.2150300',:zoom_level => 9).save
                    

Action.new(:name => '志愿服务',:for_time => true).save
Action.new(:name => '捐款',:for_amount => true).save
Action.new(:name => '捐物',:for_goods => true).save
