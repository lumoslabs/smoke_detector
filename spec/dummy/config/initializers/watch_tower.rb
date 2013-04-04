module WatchTower

  class Engine < Rails::Engine


    config.providers = [
      {
        provider: :rollbar,
        api_key: 'fake_rollbar',
        settings: {
          async: true
        }
      },
      {
        provider: :airbrake,
        api_key: 'fake_airbrake',
        settings: {
          development_environments: []
        }
      }
    ]

  end
end
