# YmContent

ym_content is Yoomee's cms

## Installation
ym_content works with Rails 3.2 upwards. You can add it to your Gemfile with:

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

Add the following line to your application.js
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

Add the following lines to the very bottom of your applications routes.rb file
```
ym_content_route :cms_admin, :path => '/'
ym_content_route :cms, :path => '/'
```

To ensure that links to permalinked content packages work set the default host is set in each relevant environment file
```
 routes.default_url_options[:host] = 'localhost'
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

To add rich content support to your project, all you need to do is

Make a migration for the Sir Trevor Image model (see lib/generators/ym_content/templates/migrations/create_sir_trevor_images.rb)

Make a migration to add sir_trevor_settings:text to the content attribute model.

Add gem to Gemfile
```
gem 'sir-trevor-rails', '~> 0.4.0'
```
Generate the partials for viewing the content

```bash
rails g sir_trevor:views
```

For some reason, the heading block doesn't generate so you will have to do this manually

# How to use

There is a new content attribute type called rich content. Add a rich content content attribute to your content type. In the view, render the Sir Trevor output

```
=render_sir_trevor @content_package.my_content_attribute_name
```

# Custom Blocks

1. Add the block javascript to app/assets/javascripts/sir_trevor_custom_blocks
2. Create a partial in the target application app/views/sir_trevor/blocks
3. Add the block name to the SIR_TREVOR_DEFAULT_BLOCKS list in content_attribute.rb in ym_content OR override in your app by placing the following code in content_attribute.rb
``` YmContent::ContentAttribute::DEFAULT_SIR_TREVOR_BLOCK_TYPES = ['Text', 'Image', 'Video', 'Heading', 'Quote', 'List', 'Alert', 'MY_CUSTOM_BLOCK'] ```

Sir Trevor JS docs: http://madebymany.github.io/sir-trevor-js/docs.html

Sir Trevor Rails docs: https://github.com/madebymany/sir-trevor-rails/blob/v4-with-link-attributes/README.md
