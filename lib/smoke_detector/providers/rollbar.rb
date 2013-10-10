module SmokeDetector::Providers

  class Rollbar < Provider

    def initialize(api_key, settings = {})
      ::Rollbar.configure do |c|
        c.environment = ::Rails.env # Rollbar sets this to 'unspecified' by default

        c.access_token = api_key
        apply_configuration_settings(c, settings)

        # set Rollbar defaults
        c.logger ||= ::Rails.logger
        c.root ||= ::Rails.root
        c.framework = "Rails: #{::Rails::VERSION::STRING}"
        c.filepath ||= ::Rails.application.class.parent_name + '.rollbar'
      end
    end

    def alert(exception, options = {})
      if data = options.delete(:data)
        exception.message << data.to_s
      end

      ::Rollbar.report_exception(exception)
    end

    def message(message, options = {})
      level = options.delete(:level) || 'info'
      ::Rollbar.report_message(message, level, options)
    end

    module ControllerMethods
      def alert_smoke_detector(exception, options = {})
        super if defined?(super)

        if data = options.delete(:data)
          exception.message << data.to_s
        end

        ::Rollbar.report_exception(exception, rollbar_request_data, rollbar_person_data)
      end
    end
  end
end
