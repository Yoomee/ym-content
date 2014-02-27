require 'ym_core'
require 'ym_permalinks'
require 'ym_users'
require 'ym_content/engine'

module YmContent
end

Dir[File.dirname(__FILE__) + '/ym_content/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/ym_content/controllers/*.rb'].each {|file| require file }

require 'cocoon'
require 'oembed'
OEmbed::Providers.register(OEmbed::Providers::Flickr,OEmbed::Providers::Instagram,OEmbed::Providers::Scribd,OEmbed::Providers::SoundCloud,OEmbed::Providers::Slideshare,OEmbed::Providers::Youtube,OEmbed::Providers::Vimeo)
