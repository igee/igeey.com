# Read abouf.factories at http://github.com/thoughtbot/factory_girl

Factory.define :lily do |f|
  f.login 'lily'
  f.email 'lily@example.com'
  f.password 'password'
  f.password_confirmation 'password'
end

Factory.define :lucy do |f|
  f.login 'lucy'
  f.email 'lucy@example.com'
  f.password 'password'
  f.password_confirmation 'password'
end

Factory.define :green do |f|
  f.login 'green'
  f.email 'green@example.com'
  f.password 'password'
  f.password_confirmation 'password'
end
