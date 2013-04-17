require 'spec_helper'

describe 'Airbrake config: An exception' do

  before do
    SmokeDetector.instance_variable_set(:@providers, [])
    SmokeDetector.register_provider(:airbrake, 'key')
  end

  it_behaves_like 'Airbrake integrated error handler'
end
