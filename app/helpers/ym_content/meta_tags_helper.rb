module YmContent::MetaTagsHelper

  def ym_content_meta_tags
    meta_tags = ''

    if @content_package.try(:hide_from_robots?)
      meta_tags += "<meta name='robots' content='noindex, nofollow' />\n"
    end

    meta_values = build_meta_values
    meta_tags += build_meta_tags(meta_values)
    meta_tags.html_safe
  end

  def build_meta_values
    if @content_package.present?

      # get site defaults
      meta_title = Settings.default_meta_title || 'Site title'
      meta_description = Settings.default_meta_description
      meta_image = "#{Settings.site_url}#{Settings.default_meta_image}"
      meta_keywords = Settings.default_meta_keywords

      # override defaults with custom meta from package
      meta_content = @content_package.get_meta_content_chunks
      meta_content.each do |mc|
        case mc.content_attribute.meta_tag_name
        when 'title'
          meta_title = mc.value
        when 'keywords'
          meta_keywords += (', ' + mc.value)
        when 'description'
          meta_description = mc.value
        when 'image'
          meta_image = mc.value
        else
          Rails.logger.info('Unsupported meta tag: #{mc.content_attribute.meta_tag_name}')
        end
      end
    end
    [meta_title, meta_description, meta_image, meta_keywords]
  end

  def build_meta_tags(meta_values)
    meta_title, meta_description, meta_image, meta_keywords = meta_values
    meta_tags = ""
    if @content_package.present?
      # build actual tags from values
      if meta_title.present?
        meta_tags << "<meta itemprop=\"name\" content=\"#{meta_title}\">\n"
        meta_tags << "<meta name=\"twitter:card\" content=\"#{meta_title}\">\n"
        meta_tags << "<meta name=\"twitter:title\" content=\"#{meta_title}\">\n"
        meta_tags << "<meta property=\"og:title\" content=\"#{meta_title}\" />\n"
      end

      if meta_description.present?
        meta_tags << "<meta itemprop=\"description\" content=\"#{meta_description}\">\n"
        meta_tags << "<meta name=\"twitter:description\" content=\"#{meta_description}\">\n"
        meta_tags << "<meta property=\"og:description\" content=\"#{meta_description}\" />\n"
      end

      if meta_image.present?
        meta_tags << "<meta itemprop=\"image\" content=\"#{meta_image.url(:host => Settings.site_url)}\">\n"
        meta_tags << "<meta property=\"og:image\" content=\"#{meta_image.url(:host => Settings.site_url)}\"/>\n"
      end

      if meta_keywords.present?
        meta_tags << "<meta name=\"keywords\" content=\"#{meta_keywords}\">\n"
      end

      meta_tags << "<meta property=\"og:url\" content=\"#{request.original_url}\" />\n"
      meta_tags << "<meta property=\"og:site_name\" content=\"#{Settings.site_name}\"/>\n"

    end
    meta_tags
  end

end
