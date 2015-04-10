Rails.application.routes.draw do
  get 'users/new'

  resources :users
   root 'users#index'
   
end
