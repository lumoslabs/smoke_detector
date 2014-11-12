require 'spec_helper'

describe SmokeDetector::Providers::Rollbar do
  let(:provider) { SmokeDetector::Providers::Rollbar.new('api_key', client_settings, settings) }
  let(:client_settings) { nil }
  let(:settings) { {} }
  let(:err) { StandardError.new('error') }
  let(:data) { {custom: :data} }

  describe '#initialize' do
    describe 'environment setting' do
      before { SmokeDetector::Providers::Rollbar.new('api_key', nil, settings) }

      it 'defaults to the Rails environment' do
        expect(::Rollbar.configuration.environment).to eql Rails.env
      end

      context 'given a specific environment' do
        let(:env) { 'staging' }
        let(:settings) { { environment: env } }

        it 'is set to the given environment' do
          expect(::Rollbar.configuration.environment).to eql env
        end
      end
    end
  end

  describe '#alert' do
    it 'reports the exception to Rollbar' do
      Rollbar.should_receive(:error).with(err)
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
      Rollbar.should_receive(:log).with(level, message, options)
      provider.message(message)
    end

    context 'when passed options' do
      let(:options) { {custom: :data} }

      it 'passes the options along as the data param' do
        Rollbar.should_receive(:log).with(level, message, options)
        provider.message(message, options)
      end

      context 'including the level' do
        let(:level) { 'debug' }
        let(:options) { {custom: :data, level: level} }

        it 'sets the message level' do
          Rollbar.should_receive(:log).with(level, message, options)
          provider.message(message, options)
        end

        it 'does not include the level in the data param' do
          Rollbar.should_receive(:log).with(level, message, options)
          provider.message(message, options)
        end
      end
    end
  end

  describe 'ControllerMethods' do
    let(:controller) do
      ActionController::Base.new.tap do |c|
        c.class.send(:include, SmokeDetector::Providers::Rollbar::ControllerMethods)
      end
    end

    describe '#alert_smoke_detector' do
      it 'notifies Rollbar of the exception' do
        Rollbar.should_receive(:error)
        controller.should_receive(:rollbar_request_data)
        controller.should_receive(:rollbar_person_data)
        controller.alert_smoke_detector(err)
      end
    end
  end

  describe "#client_settings" do
    let(:settings) { { environment: ::Rails.env } }
    let(:client_api_key) { "client_api_key"  }
    let(:hostWhiteList)  { %w(google.com yahoo.com aol.com) }
    let(:ignoredMessages) { ["Hey, ignore this", "Ignore this too"] }
    let(:personData) { { email: "yo@gabbagabba.limosine" } }

    let(:client_settings) do
      {
        api_key: client_api_key,
        hostWhiteList: hostWhiteList,
        ignoredMessages: ignoredMessages,
        payload: {
          person: personData
        }
      }
    end

    subject { provider.client_settings }

    it "merges default settings" do
      expect(subject).to include(:payload)
      expect(subject[:payload]).to include(:environment)
      expect(subject[:payload][:environment]).to eq(::Rails.env)
    end

    it "includes configured client settings" do
      expect(subject[:api_key]).to eq(client_api_key)
      expect(subject[:hostWhiteList]).to eq(hostWhiteList)
      expect(subject[:payload][:person]).to eq(personData)
    end
  end
end
