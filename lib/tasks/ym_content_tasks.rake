namespace :ym_content do
  desc 'Move to new meta tags for content_packages'
  task migrate_to_new_meta_tags: :environment do
    # for each content chunk, update the appropriate field of its content package
    meta_content_chunks.each do |chunk|
      package = chunk.content_package
      package.update_attribute("meta_#{chunk.content_attribute.meta_tag_name}", chunk.value)
    end
  end

  desc 'Destroy all old meta tags for content_packages'
  task destroy_old_meta_tags: :environment do
    meta_content_chunks.destroy_all
    meta_content_attributes.destroy_all
  end

  private

  def meta_content_attributes
    ContentAttribute.where(meta: true).where('meta_tag_name IN (?)', %w(title description image keywords))
  end

  def meta_content_chunks
    ContentChunk.where(content_attribute_id: meta_content_attributes.pluck(:id))
  end
end
