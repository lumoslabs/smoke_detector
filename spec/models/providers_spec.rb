require 'spec_helper'

describe SmokeDetector do
  let(:provider) { :rollbar }
  let(:api_key) { 'some_key' }
  let(:provider_class) { SmokeDetector::Providers::Rollbar }

  describe '.register_provider' do
    context 'with a supported provider' do
      context 'that is unregistered' do
        before do
          SmokeDetector.stub(:registered_provider?).with(provider).and_return(false)
        end

        it 'adds the provider to the SmokeDetector providers' do
          SmokeDetector.register_provider(provider, api_key)
          SmokeDetector.providers.last.should be_a provider_class
        end
      end

      context 'that is registered' do
        before do
          SmokeDetector.stub(:registered_provider?).with(provider).and_return(true)
        end

        it 'raises an error' do
          expect { SmokeDetector.register_provider(provider, api_key) }.to raise_error SmokeDetector::ProviderRegistrationError
        end
      end

    end

    context 'with an unsupported provider' do
      let(:provider) { :not_a_provider }

      it 'raises an error' do
        expect { SmokeDetector.register_provider(provider, api_key) }.to raise_error SmokeDetector::ProviderRegistrationError
      end
    end
  end

  describe '.registered_provider?' do
    subject { SmokeDetector.registered_provider?(provider) }

    context "with a supported provider" do
      context 'that is registered' do
        before do
          SmokeDetector.register_provider(provider, api_key)
        end

        it { should == true }
      end

      context 'that is unregistered' do
        it { should == false }
      end
    end

    context "with an unsupported provider" do
      let(:provider) { :not_a_provider }

      it 'raises an error' do
        expect { subject }.to raise_error SmokeDetector::ProviderRegistrationError
      end
    end
  end

  describe '.classify_provider' do
    subject { SmokeDetector.classify_provider(provider) }

    context "with a supported provider" do
      it { should == provider_class }
    end

    context "with an unsupported provider" do
      let(:provider) { :not_a_provider }

      it 'raises an error' do
        expect { subject }.to raise_error SmokeDetector::ProviderRegistrationError
      end
    end
  end
end
