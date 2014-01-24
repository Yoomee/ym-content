Rails.application.routes.draw do
  resources :content_types, :except => [:destroy] do
    resources :content_packages, :only => :new
  end
  get '/content' => 'content_types#index'
  resources :content_packages, :except => :new
end
