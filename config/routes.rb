Rails.application.routes.draw do
  get 'friendships/create'

  get 'friendships/destroy'

  resources :users
  resources :bills
  resources :friendships
  post 'friendships/search' => 'friendships#search_friendship'
  post 'bills/settle' => 'bills#settle'
  post 'users/authenticate' => 'users#authenticate'
  post 'users/searchUser' => 'users#searchUser'
  root 'users#index'
end
