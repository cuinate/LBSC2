# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Lbsc2::Application.initialize!
#log ActiveRecord
ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?
Rails::Console
