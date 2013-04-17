require 'active_support/inflector'

module SmokeDetector
  PROVIDERS = [
    :airbrake,
    :rollbar
  ]

  def self.register_provider(provider_name, api_key, settings = {})
    @providers ||= []
    raise ProviderRegistrationError, 'Unsupported Provider' unless PROVIDERS.include?(provider_name)
    raise ProviderRegistrationError, 'Provider is already registered' if registered_provider?(provider_name)
    @providers << classify_provider(provider_name).new(api_key, settings)
  end

  def self.providers
    @providers || []
  end

  def self.registered_provider?(provider_name)
    raise ProviderRegistrationError, 'Unsupported Provider' unless PROVIDERS.include?(provider_name)
    klass = classify_provider(provider_name)
    !!SmokeDetector.providers.detect { |provider| provider.is_a?(klass) }
  end

  private

  def self.classify_provider(provider_name)
    raise ProviderRegistrationError, 'Unsupported Provider' unless PROVIDERS.include?(provider_name)
    ::ActiveSupport::Inflector.constantize("SmokeDetector::Providers::#{provider_name.capitalize}")
  end
end

require 'smoke_detector/providers/provider'
SmokeDetector::PROVIDERS.each do |provider|
  require "smoke_detector/providers/#{provider}"
end
