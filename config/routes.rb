Rails.application.routes.draw do

  resources :content_types, :except => [:destroy] do
    resources :content_packages, :only => :new
  end

  get '/content' => 'content_types#index'

  resources :content_packages do
    collection do
      get 'filter/:filter' => 'content_packages#index', :as => 'filter'
    end
    member do
      get 'children'
      get 'reorder'
      put 'reorder' => 'content_packages#save_order'
      get 'search'
    end
  end

  resources :personas

end
