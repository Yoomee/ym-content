module YmContent::ContentType

  def self.included(base)
    if Rails::VERSION::MAJOR >= 4
      base.has_many :content_attributes, -> { order(:position, :id) }
      base.has_many :content_packages, -> { where(:deleted_at => nil)}
    else
      base.has_many :content_attributes, :order => :position
      base.has_many :content_packages, :conditions => {:deleted_at => nil}
    end
    base.validates_presence_of :name
    #base.send(:default_scope, { :include => :content_attributes })
    base.accepts_nested_attributes_for :content_attributes, :allow_destroy => true
    base.before_create(:set_content_attribute_positions)
    base.before_destroy(:destroyable?)
  end

  def self.default_scope
    include(:content_attributes)
  end

  def destroyable?
    content_packages.count.zero?
  end

  def missing_view?
    if viewless?
      false
    else
      ActionController::Base.view_paths.all? do |path|
        !File.exists?("#{path}/content_packages/views/#{view_name}.html.haml")
      end
    end
  end

  def package_name
    read_attribute(:package_name).presence || name.try(:downcase)
  end

  def to_s
    name
  end

  private
  def set_content_attribute_positions
    self.content_attributes.each_with_index do |content_attribute, idx|
      content_attribute.position = idx
    end
  end

end
