module GeosHelper
  def geo_list
    Geo.all.map{|geo| [geo.name,geo.id]}  
  end
  
end
