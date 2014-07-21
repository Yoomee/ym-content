Rails.application.routes.draw do

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
      get 'filter/:filter' => 'content_packages#index', :as => 'filter'
      get 'deleted'
      get 'activity'
    end
    member do
      get 'children'
      put 'delete'
      get 'reorder'
      put 'reorder' => 'content_packages#save_order'
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

end
