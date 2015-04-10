Rails.application.routes.draw do
  get 'users/new'
  post 'user/create'    
  resources :users
   root 'users#index'
   
end
