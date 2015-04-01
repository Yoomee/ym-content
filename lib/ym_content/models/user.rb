module User
  def self.included base
    base.class_eval do
      include YmUsers::User
    end
    base.scope :cms_users, -> { base.where(role: YmContent::config.cms_roles) }
  end

  def self.available_roles
    YmContent::config.cms_roles
  end

  def active_for_authentication?
    super && self.active
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end
end
