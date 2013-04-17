module SmokeDetector
  class Engine < ::Rails::Engine

    config.providers = nil

    initializer 'smoke_detector.init_error_handler' do
      config.providers.each do |provider|
        SmokeDetector.register_provider provider[:provider], provider[:api_key], provider[:settings] || {}
      end

      ActiveSupport.on_load(:action_controller) do
        include SmokeDetector::ControllerMethods
      end
    end
  end
end
