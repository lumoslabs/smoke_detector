require 'spec_helper'

describe WatchTower do
  let(:provider) { :rollbar }
  let(:api_key) { 'some_key' }
  let(:provider_class) { WatchTower::Providers::Rollbar }

  describe '.register_provider' do
    context 'with a supported provider' do
      context 'that is unregistered' do
        before do
          WatchTower.stub(:registered_provider?).with(provider).and_return(false)
        end

        it 'adds the provider to the WatchTower providers' do
          WatchTower.register_provider(provider, api_key)
          WatchTower.providers.last.should be_a provider_class
        end
      end

      context 'that is registered' do
        before do
          WatchTower.stub(:registered_provider?).with(provider).and_return(true)
        end

        it 'raises an error' do
          expect { WatchTower.register_provider(provider, api_key) }.to raise_error WatchTower::ProviderRegistrationError
        end
      end

    end

    context 'with an unsupported provider' do
      let(:provider) { :not_a_provider }

      it 'raises an error' do
        expect { WatchTower.register_provider(provider, api_key) }.to raise_error WatchTower::ProviderRegistrationError
      end
    end
  end

  describe '.registered_provider?' do
    subject { WatchTower.registered_provider?(provider) }

    context "with a supported provider" do
      context 'that is registered' do
        before do
          WatchTower.register_provider(provider, api_key)
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
        expect { subject }.to raise_error WatchTower::ProviderRegistrationError
      end
    end
  end

  describe '.classify_provider' do
    subject { WatchTower.classify_provider(provider) }

    context "with a supported provider" do
      it { should == provider_class }
    end

    context "with an unsupported provider" do
      let(:provider) { :not_a_provider }

      it 'raises an error' do
        expect { subject }.to raise_error WatchTower::ProviderRegistrationError
      end
    end
  end
end
