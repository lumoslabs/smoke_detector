require 'spec_helper'

describe 'Rollbar config: An exception' do

  before do
    SmokeDetector.instance_variable_set(:@providers, [])

    SmokeDetector.register_provider(:rollbar, 'key')
  end

  it_behaves_like 'Rollbar integrated error handler'

end
