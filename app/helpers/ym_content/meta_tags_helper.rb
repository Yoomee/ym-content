module YmContent::MetaTagsHelper

  def ym_content_meta_tags
    meta_tags = ''
    if @content_package.try(:hide_from_robots?)
      meta_tags += "<meta name='robots' content='noindex, nofollow' />\n"
    end
    meta_tags += user_generated_meta_tags
    meta_tags.html_safe
  end

  def user_generated_meta_tags
    meta_tags = ""

    if @content_package.present?
      meta_title = @content_package.content_chunk_value_by_attribute_slug('meta_title')
      meta_description = @content_package.content_chunk_value_by_attribute_slug('meta_description')
      meta_image = @content_package.content_chunk_value_by_attribute_slug('meta_image')
      meta_keywords = @content_package.content_chunk_value_by_attribute_slug('meta_keywords')

      if meta_title.present?
        meta_tags << "<meta itemprop='name' content='#{meta_title}'>\n"
        meta_tags << "<meta name='twitter:card' content='#{meta_title}'>\n"
        meta_tags << "<meta name='twitter:title' content='#{meta_title}'>\n"
        meta_tags << "<meta property='og:title' content='#{meta_title}' />\n"
      end

      if meta_description.present?
        meta_tags << "<meta itemprop='description' content='#{meta_description}'>\n"
        meta_tags << "<meta name='twitter:description' content='#{meta_description}'>\n"
        meta_tags << "<meta property='og:description' content='#{meta_description}' />\n"
      end

      if meta_image.present?
          meta_tags << "<meta itemprop='image' content='#{meta_image}'>\n"
          meta_tags << "<meta name='twitter:image:src' content='#{meta_image}'>\n"
          meta_tags << "<meta property='og:image' content='#{meta_image}'/>\n"
      end

      if meta_keywords.present?
        meta_tags << "<meta name='keywords' content='#{meta_keywords}'>\n"
      end

      meta_tags << "<meta property='og:url' content='#{request.original_url}' />\n"
      meta_tags << "<meta property='og:site_name' content='#{Settings.site_name}'/>\n"
      meta_tags << "<meta property='article:published_time' content='#{@content_package.created_at}' />\n"
      meta_tags << "<meta property='article:modified_time' content='#{@content_package.updated_at}' />\n"
    end

    meta_tags
  end

end
