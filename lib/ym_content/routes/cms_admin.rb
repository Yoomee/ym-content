class ActionDispatch::Routing::Mapper

  def ym_content_route_cms_admin(options = {})
    scope "/#{options[:path]}".squeeze('/') do
      resources :content_types do
        resources :content_packages, :only => :new
        member do
          get 'children'
          get 'duplicate'
          get 'reorder'
          put 'reorder' => 'content_types#save_order'
        end
      end

      get '/content' => 'content_types#dashboard'
      post '/attachments' => 'attachments#create'

      # ym_users_routes
      scope 'cms' do
        resources :cms_users, controller: 'cms_users'
      end

      post '/cms_users/(:id)/set_active' => 'cms_users#set_active', :as => 'set_active_user'
      post '/cms_users/create' => 'cms_users#create_user', :as => 'create_cms_user'

      resources :content_packages do
        collection do
          get 'filter/:filter' => 'content_packages#index', :as => 'filter'
          get 'deleted'
          get 'activity'
        end
        member do
          # custom actions are not supported for these routes
          # see content_package routes
          get 'children'
          put 'delete'
          get 'reorder'
          put 'save_order'
          put 'restore'
          get 'search'
          get 'activity'
          post 'upload_sir_trevor_attachment'
        end
      end

      resources :navigation_items do
        collection do
          get 'reorder'
          put 'reorder' => 'navigation_items#save_order'
          get :search
        end
        member do
          get 'reorder'
          put 'reorder' => 'navigation_items#save_order'
        end
      end

      resources :personas
      resources :meta_data
      resources :redactor_image_uploads, :only => [:index, :create]

      if YmContent::config.tags_feature
        resources :tags
        resources :tag_categories
      end
    end
  end
end
