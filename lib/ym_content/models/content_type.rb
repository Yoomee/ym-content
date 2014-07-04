module YmContent::ContentType

  def self.included(base)
    if Rails::VERSION::MAJOR >= 4
      base.has_many :content_attributes, -> { order(:position, :id) }
    else      
      base.has_many :content_attributes, :order => :position
    end
    base.has_many :content_packages, -> { where(:deleted_at => nil)}
    base.validates_presence_of :name
    #base.send(:default_scope, { :include => :content_attributes })
    base.accepts_nested_attributes_for :content_attributes, :allow_destroy => true
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

end