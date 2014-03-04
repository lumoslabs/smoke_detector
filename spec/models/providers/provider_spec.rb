require 'spec_helper'

describe SmokeDetector::Providers::Provider do
  let(:api_key) { 'some_key' }
  let(:provider) { SmokeDetector::Providers::Provider.new(api_key) }

  describe '#alert' do
    subject { provider.alert(Exception.new) }

    it 'raises an error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe '#message' do
    subject { provider.message(Exception.new) }

    it 'raises an error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe '#apply_configuration_settings' do
    subject { provider.send(:apply_configuration_settings, config, settings) }

    context 'given a valid configuration setting' do
      let(:config) { double(:config, :'setting=' => true) }
      let(:settings) { {setting: false} }

      it 'does not raise an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'given an invalid configuration setting' do
      let(:config) { double(:config) }
      let(:settings) { {setting: false} }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
