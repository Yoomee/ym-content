module YmContent::MetaDatum
  def self.included(base)
    base.image_accessor :image
    base.validates :page_slug, presence: true
    # if Rails::VERSION::MAJOR >= 4
    #   base.default_scope { order(:page_slug) }
    # else
    #   base.default_scope order(:page_slug)
    # end
  end

  # def self.default_scope
  #   order(:page_slug)
  # end

  def to_s
    "/#{page_slug}"
  end
end
