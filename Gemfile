source "https://yoomee:wLjuGMTu30AvxVyIrq3datc73LVUkvo@gems.yoomee.com"
source "http://rubygems.org"

# Declare your gem's dependencies in ym_content.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :test do
  gem 'capybara', '~> 2.1'
  gem 'capybara-webkit'
  gem 'capybara-screenshot', '~> 0.3.13'
  gem 'database_cleaner'
  gem 'launchy', '~> 2.3.0'
  gem 'shoulda-matchers'
  gem 'site_prism'
  gem 'factory_girl_rails'
  gem 'poltergeist', '~> 1.4.0'
  gem 'jquery-rails'
  gem 'coffee-rails'
  gem 'webmock'
end


group :development, :test do
  gem 'cucumber-rails', '~> 1.3', :require => false
  gem 'rspec-rails', '~> 2.0'
end
