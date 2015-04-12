Rails.application.routes.draw do
  resources :users
  post 'authenticate' => 'users#authenticate'
  root 'users#index'
end
