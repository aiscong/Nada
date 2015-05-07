json.friendships @list do |instance|
  json.id instance.id
  json.user_id instance.user_id
  json.friend_id instance.friend_id
end