module SmokeDetector::Providers
  class Airbrake < Provider

    def initialize(api_key, settings = {})
      ::Airbrake.configure do |c|
        c.api_key = api_key
        apply_configuration_settings(c, settings)
      end
    end

    def alert(exception, options = {})
      options.delete(:controller)
      message(exception, options)
    end

    def message(message, options = {})
      args = [message]
      args << {parameters: options[:data]} if options[:data].present?
      ::Airbrake.notify(*args)
    end

    module ControllerMethods
      def alert_smoke_detector(exception, options = {})
        super if defined?(super)

        notify_airbrake(exception)
      end
    end
  end
end
