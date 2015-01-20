require 'stringex'
require 'ym_core'
require 'ym_users'
require 'ym_tags'
require 'ym_activity'
require 'ym_content/engine'
require 'ym_posts'
require 'geocoder'

require_relative 'ym_content/routing'
require_relative "ym_content/permalinkable"

module YmContent
   def self.config(&block)
    yield Engine.config if block
    Engine.config
  end
end

Dir[File.dirname(__FILE__) + '/ym_content/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/ym_content/controllers/*.rb'].each {|file| require file }

require 'cocoon'
require 'oembed'
OEmbed::Providers.register(OEmbed::Providers::Flickr,OEmbed::Providers::Instagram,OEmbed::Providers::Scribd,OEmbed::Providers::SoundCloud,OEmbed::Providers::Slideshare,OEmbed::Providers::Youtube,OEmbed::Providers::Vimeo)
