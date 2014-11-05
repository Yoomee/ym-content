module YmContent::MetaTagsHelper

  def ym_content_meta_tags
    meta_tags = ''
    meta_values = build_meta_values
    meta_tags += build_meta_tags(meta_values)
    meta_tags.html_safe
  end

  # builds meta data needed for generating meta tags
  def build_meta_values
    if @content_package.present?
      # cache content_package_meta_tags_cache_key(@content_package) do

        meta_title = @content_package.meta_title || Settings.default_meta_title
        meta_description = @content_package.meta_description || Settings.default_meta_description
        meta_image = @content_package.meta_image_uid ? "#{Settings.site_url}#{@content_package.meta_image.thumb('300x300#').url}" : "#{Settings.site_url}#{Settings.default_fb_meta_image}"
        meta_keywords = @content_package.meta_keywords || Settings.default_meta_keywords

        if @content_package.hide_from_robots?
          meta_hide_from_robots = "<meta name='robots' content='noindex, nofollow' />\n"
        end
        [meta_title, meta_description, meta_image, meta_keywords, meta_hide_from_robots]
      end
    # end
  end

  # generates meta tags from data
  def build_meta_tags(meta_values)
    meta_title, meta_description, meta_image, meta_keywords = meta_values
    meta_tags = ''
    if @content_package.present?
      # build actual tags from values
      if meta_title.present?
        meta_tags << "<meta itemprop=\"name\" content=\"#{meta_title}\">\n"
        meta_tags << "<meta name=\"twitter:card\" content=\"summary\">\n"
        meta_tags << "<meta name=\"twitter:title\" content=\"#{meta_title}\">\n"
        meta_tags << "<meta property=\"og:title\" content=\"#{meta_title}\" />\n"
      end

      if meta_description.present?
        meta_tags << "<meta itemprop=\"description\" content=\"#{meta_description}\">\n"
        meta_tags << "<meta name=\"twitter:description\" content=\"#{meta_description}\">\n"
        meta_tags << "<meta property=\"og:description\" content=\"#{meta_description}\" />\n"
      end

      if meta_image.present?
        meta_tags << "<meta itemprop=\"image\" content=\"#{meta_image}\">\n"
        meta_tags << "<meta property=\"og:image\" content=\"#{meta_image}\"/>\n"
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
