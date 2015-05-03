Rails.application.routes.draw do
  get 'friendships/create'

  get 'friendships/destroy'
  resources :events
  resources :users
  resources :bills
  resources :friendships
  post 'friendships/search' => 'friendships#search_friendship'
  post 'bills/settle' => 'bills#settle'
  post 'users/authenticate' => 'users#authenticate'
  post 'users/searchUser' => 'users#searchUser'
  post 'bills/unpaid_bills' => 'bills#grab_unpaid_bills'
  post 'bills/unrec_bills' => 'bills#grab_unrec_bills'
  post 'friendships/friend_list' => 'friendships#get_friend_list'
  root 'users#index'
end
