module GeosHelper
  def geo_list
    Geo.all.map{|geo| [geo.name,geo.id]}  
  end
  
  #-_-b a helper transplant from 1kg.org
  def geo_selector(object, attr, extra_field=[], value=nil)
    geo_root = extra_field.blank? ? Geo.roots.collect{|g| [g.name, g.id]} : ([extra_field] + Geo.roots.collect{|g| [g.name, g.id]})
      value = value || 1
      geo_root_value = Geo.find(value).parent_id.blank? ? (value) : Geo.find(value).parent_id
      inputs = select_tag("#{attr}_root", options_for_select(geo_root, geo_root_value))
      if geo_root_value == value 
        inputs << raw(%Q"
          <span id='#{attr}_container'>
            <select name='#{object}[#{attr}_id]' id='#{object}_#{attr}_id'>
              <option value='#{Geo.find(value).id}' selected='selected'>#{Geo.find(value).name}</option>
            </select>
          </span>
          ")
      else
        inputs << raw(%Q"
          <span id='#{attr}_container'>
            <select name='#{object}[#{attr}_id]' id='#{object}_#{attr}_id'>
              <option value='#{Geo.find(value).id}' selected='selected'>#{Geo.find(value).name}</option>
            </select>
          </span>
        ")
      end
    
    inputs << raw(%Q"<img src='/images/icon/waiting.gif' id='#{attr}_indicator' class='indicator' style='display:none' />")
    inputs << raw(%Q"<script type='text/javascript'>
                  $('#geo_root').change(function(){
                    $.ajax({
                    url: '#{selector_geos_path}',
                    beforeSend:function(){$('#geo_indicator').show()},
                    data: 'root=' + $('##{attr}_root').val().toString() + '&object=#{object}' + '&attr=#{attr}',
                    success: function(html){
                      $('##{attr}_indicator').show();
                      $('##{attr}_container').html(html);
                      $('##{attr}_indicator').hide()
                      }
                    });
                  })
                  </script>")
    
  end
end
