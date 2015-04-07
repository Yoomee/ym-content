module YmContent::UserHelper
  def cms_user_url_and_method_create_edit(user)
    { :url => user.new_record? ? create_cms_user_path : cms_user_path(user),
      :method => user.new_record? ? :post : :put
    }
  end
end