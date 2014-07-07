module YmContent::MetaTagsHelper

  def ym_content_meta_tags
    if @content_package.try(:hide_from_robots?)
      "<meta name='robots' content='noindex, nofollow' />".html_safe
    end
  end

  def user_generated_meta_tags
    if @content_package.present?
      meta_tags = "<meta content='"
      meta_attributes = @content_package.content_type.content_attributes.select{|a| a.meta?}

      meta_attributes.each do |meta_attribute|
        default_value = ContentChunk.where(:content_package_id => @content_package.id).where(:content_attribute_id => meta_attribute.default_attribute_id).first.try(:value) if meta_attribute.default_attribute_id.present?
        user_value = ContentChunk.where(:content_package_id => @content_package.id).where(:content_attribute_id => meta_attribute.id).first.try(:value)

        meta_tags << "#{meta_attribute.meta_tag_name}=#{user_value || default_value}, "
      end

      2.times do
        meta_tags.chop!
      end

      (meta_tags << "'/>").html_safe
    end
  end

end
