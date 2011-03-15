class ChartController < ApplicationController
  def show
    [Venue,User,Saying,Plan,Record,Calling,Sync,Comment,Photo,Follow,Topic].each do |model|
        eval("@#{model.name.downcase}s_per_day = (0..30).map{|a| model.where(:created_at => a.days.ago.beginning_of_day..(a - 1).days.ago.beginning_of_day).size}.reverse")
        eval("@#{model.name.downcase}s_total = #{model.all.size}")
    end
    @douban_syncs = Sync.where(:douban => true).size
    @sina_syncs = Sync.where(:sina => true).size
    @goods_records = Record.where(:action_id => 3).size
    @time_records = Record.where(:action_id => 1).size
    @directly_plans = Plan.where(:parent_id => nil).size
    @follow_plans = Plan.where("parent_id is not null").size
  end
end
