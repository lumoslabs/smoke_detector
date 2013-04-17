[![Build Status](https://travis-ci.org/lumoslabs/smoke_detector.png)](https://travis-ci.org/lumoslabs/smoke_detector)

Smoke Detector
=============

Error Reporting Gem


Installation
-------------

Add the following to your `Gemfile`:
```
gem 'smoke_detector'
```
This assumes you're using Lumos Labs' gemfury account.

Then add the provider's gem to your gemfile. Smoke Detector currently supports Rollbar and Airbrake. For example,
```
gem 'airbrake'
gem 'rollbar'
```

Finally, create an initializer file `config/initializers/smoke_detector.rb`:
```
module SmokeDetector

  class Engine < Rails::Engine

    config.providers = [
      {provider: :airbrake,
        api_key: ENV['AIRBRAKE_KEY']
      },
      {provider: :rollbar,
        api_key: ENV['ROLLBAR_KEY']
      }
    ]

  end
end
```
Note: Only a subset of configuration parameters are currently available.


TODO
----

1. Add support for JS reporting snippets
2. Add support for all configuration settings
3. Only allow one provider at a time similar to fog's config (necessary for gem publication)
