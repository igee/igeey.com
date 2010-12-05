class StatisticsController < ApplicationController
  def show
    [Venue,User,Plan,Record,Calling,Sync,Comment,Photo].each do |model|
        eval("@#{model.name.downcase}s_per_day = (0..30).map{|a| model.where(:created_at => a.days.ago..(a - 1).days.ago).size}.reverse")
        eval("@#{model.name.downcase}s_total = #{model.all.size}")
    end
  end
end
