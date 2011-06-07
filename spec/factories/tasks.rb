# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :task do |f|
  f.user_id 1
  f.venue_id 1
  f.title 'Test Title'
  f.do_at (Time.now + 1.days)
end
