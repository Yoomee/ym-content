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

      resources :content_packages do
        collection do
          get 'filter/:filter' => 'content_packages#filter', :as => 'filter'
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
          put 'reviewed'
          put 'restore'
          get 'search'
          get 'activity'
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
    end
  end
end
