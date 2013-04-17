module SmokeDetector::Providers

  class Rollbar < Provider

    def initialize(api_key, settings = {})
      ::Rollbar.configure do |c|
        c.access_token = api_key
        c.person_username_method = settings[:person_username_method] if settings[:person_username_method].present?
        c.person_email_method = settings[:person_email_method] if settings[:person_email_method].present?
        c.project_gems = settings[:project_gems] if settings[:project_gems]
        c.use_async = !!settings[:use_async]
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
