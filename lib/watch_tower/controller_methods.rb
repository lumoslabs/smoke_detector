module WatchTower
  module ControllerMethods

    def self.included(base)
      WatchTower.providers.each do |provider|
        base.send(:include, provider.class::ControllerMethods)
      end
    end

  end
end
