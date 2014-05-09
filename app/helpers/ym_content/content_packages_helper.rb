module YmContent::ContentPackagesHelper

  def robots_meta_tag
    render('content_packages/hide_from_robots')
  end

end
