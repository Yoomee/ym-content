# Setting up ym_content on a new Rails 4 app - as at Dec 2014

## Update the Gems

Remove sqlite3

Add

```
gem ‘pg'
gem 'dotenv-rails'
gem 'dotenv-deployment'
gem 'ym_content', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_content.git"
# gem 'ym_content', :path => '~/Rails/Gems/ym_content'
gem 'ym_tags', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_tags.git", :branch => 'rails-4'
# gem 'ym_tags', :path => '~/Rails/Gems/ym_tags'
gem 'ym_core', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_core.git", :branch => 'rails-4'
# gem 'ym_core', :path => '~/Rails/Gems/ym_core'
gem 'ym_posts', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_posts.git", :branch => 'rails-4'
# gem 'ym_posts', :path => '~/Rails/Gems/ym_posts'
gem 'ym_users', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_users.git", :branch => 'rails-4'
# gem 'ym_users', :path => '~/Rails/Gems/ym_users'
gem 'ym_assets', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_assets.git"
# gem 'ym_assets', :path => '~/Rails/Gems/ym_assets'
gem 'ym_videos', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_videos.git", :branch => 'rails-4'
# gem 'ym_videos', :path => '~/Rails/Gems/ym_videos'
gem 'ym_notifications', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_notifications.git", :branch => 'rails-4'
# gem 'ym_notifications', :path => '~/Rails/Gems/ym_notifications'
gem 'ym_activity', :git => "https://deploy:#{ENV['GITLAB_AUTH_TOKEN']}@gitlab.yoomee.com/yoomee/ym_activity.git", :branch => 'rails-4'
# gem 'ym_activity', :path => '~/Rails/Gems/ym_activity'
```
Run `bundle`

## update config/database.yml to use postgres

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *default
  database: appName_development

 
test: &test
  <<: *default
  database: appName_test
```
## Install ym_content and dependencies
```
rails generate ym_users:install
rails generate ym_content:install
rails generate ym_activity:install
rails generate ym_posts:install
rails generate ym_enquiries:install //just for yoomee, not for ym_content
```
### Before creating the db
** 1. We're not using ym_permalinks as is in ym-content, but do need to add a migration for it.**

Add CreatePermalinks migration (copy from https://gitlab.yoomee.com/yoomee/ym_permalinks/blob/master/lib/generators/ym_permalinks/templates/migrations/create_permalinks.rb) 
This needs to run before add_full_path_to_permalink so you may have to chagne the timestamps in the filenames to ensure they run in the correct order

**2. Add missing file extension**
add .rb extension to create_activity_items migration file

## Create db
`rake db:create`

`rake db:migrate`

`rake db:seed`