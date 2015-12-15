class Api::UsersController < Api::BaseController

	before_action :set_auth

	def get_current_user
		@user = User.find_by(uid: current_user.uid)
		respond_with @user
	end

	def get_user
		@user = User.find(get_user_params.values_at(:user_id)).first
		respond_with @user
	end

	def get_friends
		f1 = Friendship.where(friend_id: current_user.id , accept: true)
		f2 = Friendship.where(user_id: current_user.id , accept: true)
		@friends = Array.new
		f1.each do |i|
			@friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			@friends.push(User.find(i.friend_id))
		end
	end

	def friends_of_friend
		f_id = get_user_params.values_at(:user_id)
		f1 = Friendship.where(friend_id: f_id , accept: true)
		f2 = Friendship.where(user_id: f_id , accept: true)
		@friends = Array.new
		f1.each do |i|
			@friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			@friends.push(User.find(i.friend_id))
		end
	end

	def remove_friend
		f1 = Friendship.where(user_id: current_user.id , friend_id: get_user_params.values_at(:user_id) , accept: true).destroy_all
		f2 = Friendship.where(friend_id: current_user.id , user_id: get_user_params.values_at(:user_id) , accept: true).destroy_all
	end

	def requests 
		@ids= Friendship.where(friend_id: current_user.id , accept: nil)
		@friend_request = Array.new
		@ids.each do |i|
			@friend_request.push(User.find(i.user_id))
		end
		respond_with @friend_request
	end

	def accept
		f_id = get_user_params.values_at(:user_id)
		fs = Friendship.where(user_id: f_id , friend_id: current_user.id)
		fs.each do |f|
			f.update(accept: true)
		end
	end

	def reject
		f_id = get_user_params.values_at(:user_id)
		fs = Friendship.where(user_id: f_id , friend_id: current_user.id)
		fs.each do |f|
			f.update(accept: nil)
		end
	end

	def friends_search
		@people = User.search(search_params.values_at(:content).first).order("created_at DESC")
	    @friends = Array.new

	    @people.each do |p|
	    	if Friendship.where(user_id: current_user.id, friend_id: p.id , accept: true).length == 1 || Friendship.where(user_id: p.id, friend_id: current_user.id , accept: true).length == 1
	    		@friends.push(p)	    		
	    	end
	    end
	    #byebug
	    respond_with @friends
	end

	def requests_search
		@people = User.search(search_params.values_at(:content).first).order("created_at DESC")
	    @requests = Array.new

	    @people.each do |p|
	    	if Friendship.where(user_id: p.id, friend_id: current_user.id , accept: nil).length == 1
	    		@requests.push(p)	    		
	    	end
	    end
	    respond_with @requests
	end

	def pending_search
		@people = User.search(search_params.values_at(:content).first).order("created_at DESC")
	    @pending = Array.new

	    @people.each do |p|
	    	if Friendship.where(user_id: current_user.id, friend_id: p.id , accept: nil).length == 1
	    		@pending.push(p)    		
	    	end
	    end
	    respond_with @pending
	end

	def not_friends_search
		@people = User.search(search_params.values_at(:content).first).order("created_at DESC")
	    @not_friends = Array.new

	    @people.each do |p|
	    if Friendship.where(user_id: current_user.id, friend_id: p.id , accept: nil).length == 1
	    		#@pending.push(p)
	    	elsif Friendship.where(user_id: p.id, friend_id: current_user.id , accept: nil).length == 1
	    		#@requested.push(p)
	    	elsif Friendship.where(user_id: current_user.id, friend_id: p.id , accept: true).length == 1 || Friendship.where(user_id: p.id, friend_id: current_user.id , accept: true).length == 1
	    		#@friends.push(p)
	    	else
	    		if p.id != current_user.id
	    			@not_friends.push(p)
	    		end	    		
	    	end
	    end
	    respond_with @not_friends
	end

	def add_friend
		@request = Friendship.new
		@request.user_id = current_user.id
		@request.friend_id = get_user_params.values_at(:user_id).first
		@request.accept = nil
		#byebug
	  	@request.save
	end


private

	def search_params
		params.require(:search).permit(:content)
	end

	def token_params
    	params.require(:session).permit(:appToken)
 	end

 	def get_user_params
 		params.require(:user).permit(:user_id)
 	end

 	def set_auth
	   @auth = session[:omniauth] if session[:omniauth]
	end
	
end
