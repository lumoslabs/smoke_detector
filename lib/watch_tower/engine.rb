module WatchTower
  class Engine < ::Rails::Engine

    config.providers = nil

    initializer 'watch_tower.init_error_handler' do
      config.providers.each do |provider|
        WatchTower.register_provider provider[:provider], provider[:api_key], provider[:settings] || {}
      end

      ActiveSupport.on_load(:action_controller) do
        include WatchTower::ControllerMethods
      end
    end
  end
end
