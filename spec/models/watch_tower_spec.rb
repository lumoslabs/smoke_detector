require 'spec_helper'

describe WatchTower do
  describe '.alert' do
    let(:err) { Exception.new }

    before do
      WatchTower.register_provider(:airbrake, 'key')
      WatchTower.register_provider(:rollbar, 'key')
      WatchTower.providers.size.should > 1
    end

    context 'given an exception' do
      it 'notifies the provider of the exception' do
        WatchTower.providers.each do |provider|
          provider.should_receive(:alert).once.with(err, {})
        end
        WatchTower.alert(err)
      end
    end
  end

  describe '.message' do
    context 'given a message' do
      let(:message) { "holy crap!" }

      it 'notifies the provider of the message' do
        WatchTower.providers.each do |provider|
          provider.should_receive(:message).once.with(message, {})
        end
        WatchTower.message(message)
      end
    end
  end
end
