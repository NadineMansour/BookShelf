class UsersController < ApplicationController

	before_action :set_auth

	def search
		if params[:search]
	      @people = User.search(params[:search]).order("created_at DESC")
	    end

	    @pending = Array.new
	    @friends = Array.new
	    @requested = Array.new
	    @not_friends = Array.new

	    @people.each do |p|
	    	if Friendship.where(user_id: current_user.id, friend_id: p.id , accept: nil).length == 1
	    		@pending.push(p)
	    	elsif Friendship.where(user_id: p.id, friend_id: current_user.id , accept: nil).length == 1
	    		@requested.push(p)
	    	elsif Friendship.where(user_id: current_user.id, friend_id: p.id , accept: true).length == 1 || Friendship.where(user_id: p.id, friend_id: current_user.id , accept: true).length == 1
	    		@friends.push(p)
	    	else
	    		if p.id != current_user.id
	    			@not_friends.push(p)
	    		end	    		
	    	end
	    end
	    
	end

	def show
		@quote = true
		@user = User.find(params[:id])
		@posts = Post.where(user_id: params[:id]).order("created_at DESC")
		session[:profile] = @user.id
	end

	def add_friend
		@request = Friendship.new
		@request.user_id = current_user.id
		@request.friend_id = params[:friend_id].to_i
		@request.accept = nil
	  	@request.save
	  	redirect_to @current_user
	end

	def remove
		f1 = Friendship.where(user_id: current_user.id , friend_id: params[:friend_id].to_i , accept: true).destroy_all
		f2 = Friendship.where(friend_id: current_user.id , user_id: params[:friend_id].to_i , accept: true).destroy_all
		redirect_to @current_user
	end

	def accept
		f_id = params[:friend_id].to_i
		fs = Friendship.where(user_id: f_id , friend_id: current_user.id)
		fs.each do |f|
			f.update(accept: true)
		end
		redirect_to @current_user
	end

	def reject
		f_id = params[:friend_id].to_i
		fs = Friendship.where(user_id: f_id , friend_id: current_user.id)
		fs.each do |f|
			f.update(accept: false)
		end
		redirect_to @current_user
	end

	def requests
		#not working 
		@ids= Friendship.where(friend_id: current_user.id , accept: nil)
		@friend_request = Array.new
		@ids.each do |i|
			@friend_request.push(User.find(i.user_id))
		end
	end

	def friends
		@online = false
		f1 = Friendship.where(friend_id: params[:user_id].to_i , accept: true)
		f2 = Friendship.where(user_id: params[:user_id].to_i , accept: true)
		@friends = Array.new
		f1.each do |i|
			@friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			@friends.push(User.find(i.friend_id))
		end
		if params[:user_id].to_i  == current_user.id
			@online = true
		end
	end

  	def newsfeed
  		#all my posts and my friends posts sorted by create_at
  		my_posts = current_user.posts()
  		f1 = Friendship.where(friend_id: current_user.id , accept: true)
		f2 = Friendship.where(user_id: current_user.id , accept: true)
		friends = Array.new
		f1.each do |i|
			friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			friends.push(User.find(i.friend_id))
		end
		friends_posts = Array.new
		friends.each do |f|
			friends_posts = friends_posts+f.posts
		end
		@newsfeed = (my_posts+friends_posts).sort_by!(&:created_at).sort! { |a,b| b[:created_at] <=> a[:created_at] }
  	end

  	def quotes
  		#all my quotes and my friends posts sorted by create_at
  		my_posts = current_user.posts().where(genre: "quote")
  		f1 = Friendship.where(friend_id: current_user.id , accept: true)
		f2 = Friendship.where(user_id: current_user.id , accept: true)
		friends = Array.new
		f1.each do |i|
			friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			friends.push(User.find(i.friend_id))
		end
		friends_posts = Array.new
		friends.each do |f|
			friends_posts = friends_posts+f.posts.where(genre: "quote")
		end
		@quotes = (my_posts+friends_posts).sort! { |a,b| b[:created_at] <=> a[:created_at] }
  	end

  	def reviews
  		my_posts = current_user.posts().where(genre: "review")
  		f1 = Friendship.where(friend_id: current_user.id , accept: true)
		f2 = Friendship.where(user_id: current_user.id , accept: true)
		friends = Array.new
		f1.each do |i|
			friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			friends.push(User.find(i.friend_id))
		end
		friends_posts = Array.new
		friends.each do |f|
			friends_posts = friends_posts+f.posts.where(genre: "review")
		end
		@reviews = (my_posts+friends_posts).sort! { |a,b| b[:created_at] <=> a[:created_at] }
  	end

  	def status
  		my_posts = current_user.posts().where(genre: "status")
  		f1 = Friendship.where(friend_id: current_user.id , accept: true)
		f2 = Friendship.where(user_id: current_user.id , accept: true)
		friends = Array.new
		f1.each do |i|
			friends.push(User.find(i.user_id))
		end
		f2.each do |i|
			friends.push(User.find(i.friend_id))
		end
		friends_posts = Array.new
		friends.each do |f|
			friends_posts = friends_posts+f.posts.where(genre: "status")
		end
		@status = (my_posts+friends_posts).sort! { |a,b| b[:created_at] <=> a[:created_at] }
  	end



  	#create new posts
	def new_quote
		@post = Post.new
		@quote = true
		@review = false
		@status = false
	end

	def create_quote
		@post = current_user.posts.create(post_params)
		@post.genre = "quote"
		@post.timeline_id = params[:timeline_id]
		@post.save
		redirect_to :back
	end

	def new_review
		@post = Post.new
		@review = true
		@quote = false
		@status = false
	end

	def create_review
		@post = current_user.posts.create(post_params)
		@post.genre = "review"
		@post.timeline_id = params[:timeline_id]
		@post.save
		redirect_to :back
	end	

	def new_status
		@post = Post.new
		@status = true
		@quote = false
		@review = false
	end

	def create_status
		@post = current_user.posts.create(post_params)
		@post.content = "N/A"
		@post.genre = "status"
		@post.timeline_id = params[:timeline_id]
		@post.save
		redirect_to :back
	end

	
	private

	def set_auth
	   @auth = session[:omniauth] if session[:omniauth]
	end
	
end
