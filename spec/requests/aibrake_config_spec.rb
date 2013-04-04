require 'spec_helper'

describe 'Airbrake config: An exception' do

  before do
    WatchTower.instance_variable_set(:@providers, [])
    WatchTower.register_provider(:airbrake, 'key')
  end

  it_behaves_like 'Airbrake integrated error handler'
end
