# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Igee::Application.initialize!
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&laquo; 上一页'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '&raquo; 下一页'