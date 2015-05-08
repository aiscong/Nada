class FriendshipsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :sign_in_user
  
  def create
    friend = User.find_by_email(params[:friend_email])
    unless friend.present?
      render :json => {message: 'Unable to find friend id'}, status: :bad_request and return
    end
    @friend = friend
    @friendship = @cur_user.friendships.build(friend_id: @friend.id)
    @friendship_reverse = @friend.friendships.build(friend_id: @cur_user.id)
    if @friendship.save and @friendship_reverse.save
      @list = Array.new
      @list.push @friendship
      @list.push @friendship_reverse
      render :show
    else
      render :json => {message: 'Failed to build friendship'}, status: :bad_request and return
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.destroy
      render :json => {message: 'Unfriend successfully'}, status: :ok and return
    else
      render :json => {message: 'Unfriend failed'}, status: :internal_server_error and return
    end
  end
  
  def search_friendship
    friendship = @cur_user.friendships.find_by_friend_id(params[:friend_id])
    unless friendship.present?
      render :json => {message: 'Unable to find the friendship'}, status: :bad_request and return
    end
    @friendship = friendship
    render :show
  end
  
  def get_friend_list
    @friends = @cur_user.friends
  end
  
  private
    def sign_in_user
      cur_user_id = params[:cur_user_id]
      if not cur_user_id
        render :json => {message: 'Missing current user id'}, status: :bad_request and return
      end
      cur_user = User.find_by_id(params[:cur_user_id])
      unless cur_user.present?
        render :json => {message: 'Unable to find current user'}, status: :bad_request and return
      end
      if cur_user.sign_in(params[:password]) == false
        render :json => {message: 'Wrong password'}, status: :bad_request and return
      end
      @cur_user = cur_user
    end
end
