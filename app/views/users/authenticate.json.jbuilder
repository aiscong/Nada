json.extract! @user, :id, :email
json.created_at @user.created_at.to_formatted_s

