module YmContent::ContentType

  def self.included(base)
    base.has_many :content_attributes, :order => :position
    base.has_many :content_packages
    base.validates_presence_of :name
    base.accepts_nested_attributes_for :content_attributes, :allow_destroy => true
  end

  def has_view?
    ActionController::Base.view_paths.any? do |path|
      File.exists?("#{path}/content_packages/views/#{view_name}.html.haml")
    end
  end

  def package_name
    read_attribute(:package_name).presence || name.try(:downcase)
  end

end