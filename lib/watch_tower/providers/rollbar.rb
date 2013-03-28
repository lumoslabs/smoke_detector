module WatchTower::Providers

  class Rollbar < Provider

    def initialize(api_key, settings = {})
      self.extend ::Rollbar::ExceptionReporter

      ::Rollbar.configure do |c|
        c.access_token = api_key
        c.person_username_method = settings[:person_username_method] if settings[:person_username_method].present?
        c.person_email_method = settings.rollbar[:person_email_method] if settings[:person_email_method].present?
        c.project_gems = settings[:project_gems] if settings[:project_gems]
        c.use_async = !!settings[:use_async]
      end
    end


    def alert(exception, options = {})
      if data = options.delete(:data)
        exception.message << data.to_s
      end

      if controller = options.delete(:controller)
        report_exception_to_rollbar(controller.request.env, exception)
      else
        ::Rollbar.report_exception(exception)
      end
    end

    def message(message, options = {})
      level = options.delete(:level) || 'info'
      ::Rollbar.report_message(message, level, options)
    end

  end

end
