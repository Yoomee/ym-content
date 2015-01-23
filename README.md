# YmContent

ym_content is Yoomee's cms

## Installation
um_content works with Rails 3.2 upwards. You can add it to your Gemfile with:
```
gem 'ym_content'
```

Run the bundle command to install it.

After you install ym_content, you need to run the generator:
```
rails generate ym_content:install
```
This will copy controllers, models, migrations and tests into your app.

Then run the migrations:
```
rake db:migrate
```

Add the following line to your application.js.coffee
```
#= require ym_content
```

Add the following line to your application.scss
```
*= require ym_content
```

Add the following line to the header section of your application layout
```
=ym_content_meta_tags
```

## Settings

### Meta tag defaults

In your applications config/settings.yml use the following settings
to set meta tag defaults:

```
live_site_url: http://vinspired.com
default_meta_title: Your site title
default_meta_description: Your site description
default_meta_keywords: comma, separated, keywords
default_fb_meta_image: /absolute/path/to/your-image.jpg
default_twitter_meta_image: /absolute/path/to/your-image.jpg
```

## Tests

Tests will be copied to your application, to enable you to change and override this gem, while still maintaining test coverage.

To run the tests in this gem in the dummy application:
```
 rake -f test/dummy/Rakefile db:drop db:create db:migrate db:test:prepare
 bundle exec rake
```
To run the tests individually you can also run
```
 cucumber
 rspec
```

## Sir Trevor

To add rich content support to your project, all you maneed to do is 

Make a migration for the Sir Trevor Image model (see lib/generators/ym_content/templates/migrations/create_sir_trevor_images.rb)

Add gem to Gemfile
```
gem 'sir-trevor-rails', '~> 0.4.0'
```
Generate the partials for viewing the content

```bash
rails g sir_trevor:views
```

Sir Trevor JS docs: http://madebymany.github.io/sir-trevor-js/docs.html

Sir Trevor Rails docs: https://github.com/madebymany/sir-trevor-rails/blob/v4-with-link-attributes/README.md
