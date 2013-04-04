module WatchTower::Providers
  class Airbrake < Provider

    def initialize(api_key, settings = {})
      ::Airbrake.configure do |c|
        c.api_key = api_key
        c.development_environments = settings[:development_environments] if settings[:development_environments]
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
      def alert_watch_tower(exception, options = {})
        super if defined?(super)

        notify_airbrake(exception)
      end
    end
  end
end
