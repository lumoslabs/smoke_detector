require 'spec_helper'

describe 'Multi-provider config: An exception' do

  before do
    SmokeDetector.instance_variable_set(:@providers, [])

    SmokeDetector.register_provider(:rollbar, 'key')
    SmokeDetector.register_provider(:airbrake, 'key')
    SmokeDetector.providers.size.should == 2
  end

  it_behaves_like 'Rollbar integrated error handler'
  it_behaves_like 'Airbrake integrated error handler'

end
