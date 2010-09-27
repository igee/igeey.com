# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

geos = Geo.create([
                    { :name => '北京',:latitude => '39.9046670',:longitude => '116.4081980',:zoom_level => 9 },
                    { :name => '天津',:latitude => '39.1208760',:longitude => '117.2150300',:zoom_level => 9 }
                    ])

actions = Action.create([
                    { :name => '公益旅行',:for_time => true},
                    { :name => '捐款',:for_amount => true },
                    { :name => '捐物',:for_goods => true },
                    ])