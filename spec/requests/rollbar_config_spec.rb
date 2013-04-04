require 'spec_helper'

describe 'Rollbar config: An exception' do

  before do
    WatchTower.instance_variable_set(:@providers, [])

    WatchTower.register_provider(:rollbar, 'key')
  end

  it_behaves_like 'Rollbar integrated error handler'

end
