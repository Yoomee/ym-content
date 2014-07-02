module YmContent::MetaTagsHelper

  def ym_content_meta_tags
    if @content_package.try(:hide_from_robots?)
      "<meta name='robots' content='noindex, nofollow' />".html_safe
    end
  end

  def user_generated_meta_tags
    if @content_package.present?
      meta_tags = "<meta content='"
      @content_package.content_chunks.select{|c| c.content_attribute.meta == true}.each do |chunk|
        meta_tags << "#{chunk.content_attribute.meta_tag_name}=#{chunk.value}, "
      end

      2.times do
        meta_tags.chop!
      end

      (meta_tags << "'/>").html_safe
    end
  end

end
