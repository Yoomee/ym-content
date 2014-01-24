Dummy::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    get 'login', :to => 'devise/sessions#new', :as => 'sign_in'
    delete 'logout', :to => 'devise/sessions#destroy', :as => 'sign_out'
    get 'sign-up', :to => 'devise/registrations#new', :as => 'sign_up'
    get 'change-password', :to => 'devise/registrations#edit', :as => 'change_password'
    get 'reset-password', :to => 'devise/passwords#new', :as => 'reset_password'
  end

  root :to => 'content_types#index'

end
