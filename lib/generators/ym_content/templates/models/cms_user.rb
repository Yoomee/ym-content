class CmsUser < ActiveRecord::Base
  self.table_name = 'users'

  include YmContent::CmsUser
end