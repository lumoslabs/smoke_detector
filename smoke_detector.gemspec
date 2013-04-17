$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smoke_detector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smoke_detector"
  s.version     = SmokeDetector::VERSION
  s.authors     = ["Chris Friedrich"]
  s.email       = ["cfriedrich@lumoslabs.com"]
  s.homepage    = "https://github.com/lumoslabs/smoke_detector"
  s.summary     = "Errors Alerts"
  s.description = "Provides a single interface for posting errors to multiple error reporting providers (Airbrake and Rollbar)"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails",       "~> 3.2.12"
  s.add_dependency "airbrake",    "~> 3.1.8"
  s.add_dependency "rollbar",     "~> 0.9.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'pry-rescue'
  s.add_development_dependency 'pry-stack_explorer'
  s.add_development_dependency 'ruby-debug19'
end
