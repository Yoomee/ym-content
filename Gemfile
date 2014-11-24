source "https://yoomee:wLjuGMTu30AvxVyIrq3datc73LVUkvo@gems.yoomee.com"
source "http://rubygems.org"

# Declare your gem's dependencies in ym_content.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec
gem 'ym_users',       :git => "git@gitlab.yoomee.com:yoomee/ym_users.git", :branch => "rails-4"
gem 'ym_core',        :git => "git@gitlab.yoomee.com:yoomee/ym_core.git", :branch => "rails-4"
gem 'ym_posts',       :git => "git@gitlab.yoomee.com:yoomee/ym_posts.git", :branch => "rails-4"
gem 'ym_tags',        :git => "git@gitlab.yoomee.com:yoomee/ym_tags.git", :branch => "rails-4"
gem 'ym_videos',      :git => "git@gitlab.yoomee.com:yoomee/ym_videos.git", :branch => "rails-4"
gem 'ym_assets',      :git => "git@gitlab.yoomee.com:yoomee/ym_assets.git"

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
  gem 'byebug'
  gem 'cucumber-rails', '~> 1.3', :require => false
  gem 'rspec-rails', '~> 2.0'
  gem 'spring'
  gem 'spring-commands-cucumber'
end
