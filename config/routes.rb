Rails.application.routes.draw do
  resources :users
  resources :bills
  post 'users/authenticate' => 'users#authenticate'
  root 'users#index'
end
