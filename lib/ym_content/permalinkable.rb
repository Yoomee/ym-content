module YmContent::Permalinkable

  extend ActiveSupport::Concern
  included do
    has_one :permalink, -> { where(:active => true) }, :as => :resource, :autosave => true
    has_many :permalinks, :as => :resource, :autosave => true, :dependent => :destroy
    before_validation :set_permalink_path, :set_permalink_full_path
    after_validation :set_permalink_errors
    after_save :sync_child_full_paths
  end

  def permalink_path
    permalink.try(:path)
  end

  def permalink_path=(val)
    (self.permalink || self.build_permalink).path = val
  end

  private

  def set_permalink_errors
    permalink_errors = permalink.try(:errors).try(:get, :path)
    errors.add(:permalink_path, permalink_errors) if permalink_errors.present?
  end

  def set_permalink_path
    return true unless permalink
    if permalink.path.present?
      self.permalink.path = permalink.path.to_url
    else
      self.permalink.generate_unique_path!(to_s)
    end
  end

  def set_permalink_full_path
    return if new_record?
    self.permalink.full_path = self.parent ? "#{CGI::escape(self.parent.permalink.full_path).gsub('%2F', '/')}/#{self.permalink.path}".squeeze('/') : "/#{self.permalink.path}"
  end

  def sync_child_full_paths
    return if new_record? || permalink.nil?
    children.each{ |p| p.save! } if permalink.previous_changes[:full_path]
  end

end