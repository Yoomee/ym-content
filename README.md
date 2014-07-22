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
default_meta_image: /absolute/path/to/your-image.jpg
```

## Tests

Tests will be copied to your application, to enable you to change and override this gem, while still maintaining test coverage.

To run the tests in this gem in the dummy application:
```
 rake -f test/dummy/Rakefile db:drop db:create db:migrate test:prepare
 cucumber
 rspec
```
