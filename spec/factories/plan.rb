# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :plan do |f|
  f.association :task, :factory=>:task
  f.association :user, :factory=>:user
  f.content 'plan content'
end

