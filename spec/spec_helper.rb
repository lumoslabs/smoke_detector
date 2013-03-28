ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:each) do
    WatchTower.instance_variable_set(:@providers, @providers)
    WatchTower.register_provider(:rollbar, 'some_key')
    WatchTower.providers.size.should == 1

    # sandbox services
    Airbrake.stub(:send_notice)
    Rollbar.stub(:schedule_payload)
  end

  config.after(:each) do
    WatchTower.instance_variable_set(:@providers, @providers)
  end
end
