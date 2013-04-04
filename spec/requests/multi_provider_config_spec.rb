require 'spec_helper'

describe 'Multi-provider config: An exception' do

  before do
    WatchTower.instance_variable_set(:@providers, [])

    WatchTower.register_provider(:rollbar, 'key')
    WatchTower.register_provider(:airbrake, 'key')
    WatchTower.providers.size.should == 2
  end

  it_behaves_like 'Rollbar integrated error handler'
  it_behaves_like 'Airbrake integrated error handler'

end
