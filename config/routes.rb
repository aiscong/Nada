Rails.application.routes.draw do
  resources :events
  resources :users
  resources :bills
  resources :friendships
  post 'events/event_list' => 'events#get_event_list'
  post 'friendships/search' => 'friendships#search_friendship'
  post 'bills/settle' => 'bills#settle'
  post 'users/authenticate' => 'users#authenticate'
  post 'users/searchuser' => 'users#searchUser'
  post 'bills/unpaid_bills' => 'bills#grab_unpaid_bills'
  post 'bills/unrec_bills' => 'bills#grab_unrec_bills'
  post 'friendships/friend_list' => 'friendships#get_friend_list'
  post 'bills/billreminder' => 'bills#pushReminder'
  match 'users/regid/:id' => 'users#update_reg_id', :via => :put
  post 'users/activity/' => 'users#activity'
  root 'users#index'
end
