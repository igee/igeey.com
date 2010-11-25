namespace :timing do
  
  desc "Tag overdue callings :close => true"
  task :close_overdue_callings => :environment do
    Calling.timing.not_closed.each do |c|
      c.update_attributes(:close => true) if  Date.today > c.do_at.to_date
    end
  end 
  
end
