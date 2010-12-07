class ChartController < ApplicationController
  def show
    [Venue,User,Plan,Record,Calling,Sync,Comment,Photo,Follow,Topic].each do |model|
        eval("@#{model.name.downcase}s_per_day = (0..30).map{|a| model.where(:created_at => (a + 1).days.ago..a.days.ago).size}.reverse")
        eval("@#{model.name.downcase}s_total = #{model.all.size}")
    end
  end
end
