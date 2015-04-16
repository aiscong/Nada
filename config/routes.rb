Rails.application.routes.draw do
  resources :users
  post 'users/authenticate' => 'users#authenticate'
  root 'users#index'
end
