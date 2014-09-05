module YmContent::CacheHelper
  def content_package_cache_key(content_package)
    cache_key(content_package)
  end

  def content_package_meta_tags_cache_key(content_package)
    cache_key(content_package, 'content_package_meta_tags')
  end

  private
  def cache_key(content_package, key_name = 'content_package')
    "#{key_name}_#{content_package.id}_#{Time.parse(content_package.updated_at.to_s).to_i}"

  end
end
