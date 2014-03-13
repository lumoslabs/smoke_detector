module SmokeDetector

  class Engine < Rails::Engine


    config.providers = [
      {
        provider: :rollbar,
        api_key: 'fake_rollbar',
        client_api_key: 'fake_rollbar_client',
        settings: {
          use_async: true,
          js_url_filter: '^https?:\/\/.*localhost.*'
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
