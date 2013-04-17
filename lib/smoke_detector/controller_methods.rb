module SmokeDetector
  module ControllerMethods

    def self.included(base)
      SmokeDetector.providers.each do |provider|
        base.send(:include, provider.class::ControllerMethods)
      end
    end

  end
end
