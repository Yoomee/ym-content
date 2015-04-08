module YmContent::CmsUser
  def self.included base
    base.class_eval do
      include YmUsers::User
    end
    base.table_name = 'users'
    base.scope :all_users, -> { base.where(role: YmContent::config.cms_roles) }
    base.extend(ClassMethods)
  end

  module ClassMethods

    def available_roles
      YmContent::config.cms_roles
    end

  end

  def active_for_authentication?
    super && self.active
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end
end
