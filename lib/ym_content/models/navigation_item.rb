module YmContent::NavigationItem

  def self.included(base)
    base.belongs_to :parent, :class_name => 'NavigationItem'
    base.has_one :grandparent, :through => :parent, :source => :parent

    if Rails::VERSION::MAJOR >= 4
      base.has_many :children, -> { order(:position) }, :class_name => 'NavigationItem', :foreign_key => :parent_id
    else
      base.has_many :children, :class_name => 'NavigationItem', :order => :position, :foreign_key => :parent_id
    end

    base.belongs_to :resource, :polymorphic => true

    base.send(:attr_writer, :link)
    base.image_accessor :image
    base.image_accessor :logo

    base.validates :title, :presence => true

    base.before_validation :process_link

    base.scope :root, lambda{ base.where(:parent_id => nil).order(:position) }
    base.scope :level_two, lambda{ base.joins(:parent).where(:parents_navigation_items => {:parent_id => nil})}
    base.scope :level_three, lambda{ base.joins(:grandparent).where(:grandparents_navigation_items => {:parent_id => nil})}
  end

  def depth
    parents.size
  end

  def linkable
    url.presence || resource
  end

  def name
    title
  end

  def parents
    [parent, parent.try(:parents)].flatten.compact
  end

  private
  def process_link
    if @link == ''
      self.url = nil
      self.resource = nil
    elsif !@link.nil?
      path = @link.to_s.sub(/^\//,'')
      if permalink = Permalink.find_by_path(path)
        self.resource = permalink.resource
        self.url = nil
      else
        self.url = @link
        self.resource = nil
      end
    end
  end

end
