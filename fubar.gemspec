$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fubar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fubar"
  s.version     = Fubar::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Fubar."
  s.description = "TODO: Description of Fubar."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.12"

  s.add_development_dependency "sqlite3"
end
