module SmokeDetector::Providers

  class Provider
    attr_accessor :controller_proc

    def alert(exception, options = {})
      raise NotImplementedError
    end

    def message(message, options = {})
      raise NotImplementedError
    end

    private

    def apply_configuration_settings(configuration, settings)
      settings.each do |setting, value|
        raise(ArgumentError, "#{setting} is not a valid #{self.class.name} configuration setting") unless configuration.respond_to?("#{setting}=")
        configuration.send("#{setting}=", value)
      end
    end
  end

end
