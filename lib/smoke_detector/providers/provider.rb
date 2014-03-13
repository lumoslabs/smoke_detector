module SmokeDetector::Providers

  class Provider
    attr_accessor :controller_proc

    def initialize(api_key, client_api_key = nil, settings = {})
      @client_api_key = client_api_key
      @js_url_filter  = settings.delete(:js_url_filter)
    end

    def alert(exception, options = {})
      raise NotImplementedError
    end

    def message(message, options = {})
      raise NotImplementedError
    end

    def client_monitoring_code
      ''
    end

    private

    def client_api_key
      @client_api_key
    end

    def apply_configuration_settings(configuration, settings)
      settings.each do |setting, value|
        raise(ArgumentError, "#{setting} is not a valid #{self.class.name} configuration setting") unless configuration.respond_to?("#{setting}=")
        configuration.send("#{setting}=", value)
      end
    end
  end

end
