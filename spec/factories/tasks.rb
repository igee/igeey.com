# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :task do |f|
  f.user_id 1
  f.venue_id 1
  f.title 'Test Title'
end
