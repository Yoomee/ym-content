$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ym_content/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ym_content"
  s.version     = YmContent::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of YmContent."
  s.description = "TODO: Description of YmContent."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 3.2.13'
  s.add_dependency 'ym_core', '~> 1.1.4'
  s.add_dependency 'ym_permalinks', '~> 1.0.1'
  s.add_dependency 'ym_users', '~> 1.1.1'
  s.add_dependency 'cocoon'

  s.add_development_dependency "sqlite3"

  # s.add_development_dependency 'rspec-rails'
  # s.add_development_dependency 'factory_girl_rails'
  # s.add_development_dependency 'shoulda-matchers'
  # s.add_development_dependency 'capybara', '~> 1.1.0'
  # s.add_development_dependency 'capybara-webkit'
  # s.add_development_dependency 'database_cleaner', '1.2.0'
  # s.add_development_dependency 'guard-rspec'
  # s.add_development_dependency 'growl'
  # s.add_development_dependency 'geminabox'
  # s.add_development_dependency 'ym_tools', '~> 0.1.10'
  # s.add_development_dependency 'listen', '~> 1.3.1'
end