class Permalink < ActiveRecord::Base

  include YmCore::Model

  belongs_to :resource, :polymorphic => true

  validates :full_path, :presence => true, :uniqueness => {:case_sensitive => false, :scope => :active}

  validate :path_does_not_match_existing_route
  validate :path_is_valid_url

  after_update :create_inactive_permalink
  after_update :delete_duplicate_permalinks

  scope :active, -> { where(active: true) }

  def initialize(*args)
    super(*args)
    generate_unique_path!
  end

  def generate_unique_path!(title = resource.to_s)

    if path.blank? && title.present?
      path_name_root = title.parameterize
      unique_path_name = path_name_root.dup
      permalinks = new_record? ? self.class : self.class.where("id != ?",self.id)
      count = 0
      while permalinks.exists?(:path => unique_path_name)
        count += 1
        unique_path_name = "#{path_name_root}-#{count}"
      end
      self.path = unique_path_name
    end
  end

  def resource_path
    "/#{resource_type.tableize}/#{resource_id}"
  end

  def self.find_from_url(url)
    find_by_attr = YmContent.config.nested_permalinks ? :full_path : :path
    permalink_path = "#{find_by_attr == :full_path ? '/' : ''}#{url}".squeeze('/').downcase
    # find_by_<method> is deprecated in rails 4
    if Rails::VERSION::MAJOR >= 4
      Permalink.find_by(find_by_attr => permalink_path)
    else
      Permalink.send("find_by_#{find_by_attr}", permalink_path)
    end
  end

  private
  def create_inactive_permalink
    return unless path_changed? || full_path_changed?
    resource.permalinks.create(:active => false, :path => path_was, :full_path => full_path_was)
  end

  def delete_duplicate_permalinks
    Permalink.without(self).where(:path => path, :full_path => full_path, :active => false).delete_all
  end

  def path_does_not_match_existing_route
    existing_routes = Rails.application.routes.routes.collect do |route|
      if YmContent.config.nested_permalinks
        route.path.spec.to_s.split(/\(/).try(:[],1)
      else
        route.path.spec.to_s.split(/\/|\(/).try(:[],1)
      end
    end.uniq.compact
    if existing_routes.include?(path)
      errors.add(:path, "has already been taken")
    end
  end

  def path_is_valid_url
    if path.present? && (path != path.to_url.parameterize)
      errors.add(:path, "is invalid")
    end
  end

end
