# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def makestory
  @makestory ||= User.where(:login=>'makestory').first
  if @makestory.nil?
    user = User.new(:login=>'makestory',:email=>'makestory@example.com',:password=>'123456',:password_confirmation=>'123456')
    @makestory = user if user.save
  end
end

def mhb
  @mhb ||= User.where(:login=>'mhb').first
  if @mhb.nil?
    user = User.new(:login=>'mhb',:email=>'mhb@example.com',:password=>'123456',:password_confirmation=>'123456')
    @mhb = user if user.save
  end
end

def andrew
  @andrew ||= User.where(:login=>'andrew').first
  if @andrew.nil?
    user = User.new(:login=>'andrew',:email=>'andrew@example.com',:password=>'123456',:password_confirmation=>'123456')
    @andrew = user if user.save
  end
end