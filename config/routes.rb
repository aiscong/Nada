Rails.application.routes.draw do
  resources :users
  resources :bills
  post 'bills/settle' => 'bills#settle'
  post 'users/authenticate' => 'users#authenticate'
  post 'users/searchUser' => 'users#searchUser'
  root 'users#index'
end
