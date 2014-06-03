Rails.application.routes.draw do

  resources :content_types do
    resources :content_packages, :only => :new
    member do
      get 'children'
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
      get 'reorder'
      put 'reorder' => 'content_packages#save_order'
      put 'restore'
      get 'search'
      get 'activity'
    end
  end

  resources :personas

end
