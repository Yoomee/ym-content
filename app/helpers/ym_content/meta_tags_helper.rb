module YmContent::MetaTagsHelper

  def ym_content_meta_tags
    if @content_package.try(:hide_from_robots?)
      "<meta name='robots' content='noindex, nofollow' />".html_safe
    end
  end

end
