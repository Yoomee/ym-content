module YmContent::Permalinkable

  extend ActiveSupport::Concern
  included do
    if Rails::VERSION::MAJOR >= 4
      has_one :permalink, -> { where(:active => true) }, :as => :resource, :autosave => true
    else
      has_one :permalink, :conditions => { :active => true }, :as => :resource, :autosave => true
    end
    has_many :permalinks, :as => :resource, :autosave => true, :dependent => :destroy
    validates :permalink, :presence => true, unless: 'viewless?', on: :update
    before_validation :set_permalink_path, :set_permalink_full_path
    after_validation :set_permalink_errors
    after_save :sync_child_full_paths
  end

  def permalink_path
    permalink.try(:path)
  end

  def permalink_full_path
    permalink.try(:full_path)
  end

  def permalink_path=(val)
    (self.permalink || self.build_permalink).path = val
  end

  def permalink_display_path
    if YmContent.config.nested_permalinks
      "/#{permalink_full_path}/".squeeze '/'
    else
      "/#{permalink_path}/".squeeze '/'
    end
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
    return if permalink.nil? || (self.parent && self.parent.permalink && self.parent.permalink.full_path.nil?)
    self.permalink.full_path = self.parent && !self.parent.viewless? ? "#{CGI::escape(self.parent.permalink.full_path).gsub('%2F', '/')}/#{self.permalink.path}".squeeze('/') : "/#{self.permalink.path}"
  end

  def sync_child_full_paths
    return if new_record? || permalink.nil?
    if permalink.previous_changes[:full_path]
      children.each do |x|
        x.permalinks.create(:active => false, :path => x.permalink.path, :full_path => "#{x.permalink.full_path}") unless x.permalink.nil? || ENV['RAKE_PERMALINK_RUNNING'] == 'true'
        x.save!
      end
    end
  end

end