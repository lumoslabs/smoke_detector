module SmokeDetector::Providers

  class Provider
    attr_accessor :controller_proc

    def alert(exception, options = {})
      raise NotImplementedError
    end

    def message(message, options = {})
      raise NotImplementedError
    end
  end

end
