require 'spec_helper'

describe WatchTower::Providers::Airbrake do
  let(:provider) { WatchTower::Providers::Airbrake.new('api_key', settings) }
  let(:settings) { {} }
  let(:err) { mock('error', backtrace: [], message: 'bad news') }
  let(:data) { {custom: :data} }

  describe '#alert' do
    it 'notifies Airbrake of the exception' do
      Airbrake.should_receive(:notify).with(err)
      provider.alert(err)
    end

    context 'when passed a controller option' do
      it 'ignores the option' do
        Airbrake.should_receive(:notify).with(err)
        provider.alert(err, controller: mock('controller'))
      end
    end

    context 'when passed a data option' do
      it 'includes the data in the Airbrake parameters' do
        Airbrake.should_receive(:notify).with(err, parameters: data)
        provider.alert(err, data: data)
      end
    end

  end

  describe '#message' do
    let(:message) { 'hello airbrake' }

    it 'notifies Airbrake of the message' do
      Airbrake.should_receive(:notify).with(message)
      provider.message(message)
    end

    context 'when passed options' do
      it 'includes the options in the Airbrake parameters' do
        Airbrake.should_receive(:notify).with(message, parameters: data)
        provider.message(message, data: data)
      end
    end
  end

  describe 'ControllerMethods' do
    let(:controller) do
      ActionController::Base.new.tap do |c|
        c.class.send(:include, WatchTower::Providers::Airbrake::ControllerMethods)
        c.stub(:rollbar_request_data)
        c.stub(:rollbar_person_data)
      end
    end

    describe '#alert_watch_tower' do
      it 'notifies Airbrake of the exception' do
        controller.should_receive(:notify_airbrake)
        controller.alert_watch_tower(err)
      end
    end
  end
end
