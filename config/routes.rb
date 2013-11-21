Rails.application.routes.draw do
  resources :content_types, :except => [:destroy]
  resources :content_packages
end
