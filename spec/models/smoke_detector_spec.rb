require 'spec_helper'

describe SmokeDetector do
  describe '.alert' do
    let(:err) { Exception.new }

    before do
      SmokeDetector.register_provider(:airbrake, 'key')
      SmokeDetector.register_provider(:rollbar, 'key')
      SmokeDetector.providers.size.should > 1
    end

    context 'given an exception' do
      it 'notifies the provider of the exception' do
        SmokeDetector.providers.each do |provider|
          provider.should_receive(:alert).once.with(err, {})
        end
        SmokeDetector.alert(err)
      end
    end
  end

  describe '.message' do
    context 'given a message' do
      let(:message) { "holy crap!" }

      it 'notifies the provider of the message' do
        SmokeDetector.providers.each do |provider|
          provider.should_receive(:message).once.with(message, {})
        end
        SmokeDetector.message(message)
      end
    end
  end
end
