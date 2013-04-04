require 'spec_helper'

describe WatchTower::Providers::Rollbar do
  let(:provider) { WatchTower::Providers::Rollbar.new('api_key', settings) }
  let(:settings) { {} }
  let(:err) { StandardError.new('error') }
  let(:data) { {custom: :data} }

  describe '#alert' do
    it 'reports the exception to Rollbar' do
      Rollbar.should_receive(:report_exception).with(err)
      provider.alert(err)
    end

    context 'when passed a data option' do
      it 'includes the data in the exception message' do
        err.message.should_receive(:<<).with(data.to_s)
        provider.alert(err, data: data)
      end
    end

  end

  describe '#message' do
    let(:message) { 'Hello Rollbar' }
    let(:level) { 'info' }
    let(:options) { {} }

    it 'reports the message to Rollbar' do
      Rollbar.should_receive(:report_message).with(message, level, options)
      provider.message(message)
    end

    context 'when passed options' do
      let(:options) { {custom: :data} }

      it 'passes the options along as the data param' do
        Rollbar.should_receive(:report_message).with(message, level, options)
        provider.message(message, options)
      end

      context 'including the level' do
        let(:level) { 'debug' }
        let(:options) { {custom: :data, level: level} }

        it 'sets the message level' do
          Rollbar.should_receive(:report_message).with(message, level, options)
          provider.message(message, options)
        end

        it 'does not include the level in the data param' do
          Rollbar.should_receive(:report_message).with(message, level, options)
          provider.message(message, options)
        end
      end
    end
  end

  describe 'ControllerMethods' do
    let(:controller) do
      ActionController::Base.new.tap do |c|
        c.class.send(:include, WatchTower::Providers::Rollbar::ControllerMethods)
      end
    end

    describe '#alert_watch_tower' do
      it 'notifies Rollbar of the exception' do
        Rollbar.should_receive(:report_exception)
        controller.should_receive(:rollbar_request_data)
        controller.should_receive(:rollbar_person_data)
        controller.alert_watch_tower(err)
      end
    end
  end
end
