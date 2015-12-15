class Api::PostsController < Api::BaseController

	def get_timeline
		@posts = (current_user.posts + Post.where(timeline_id: current_user.id)).uniq
		respond_with @posts
	end

	def friends_posts
		@posts = (Post.where(user_id: friend_params.values_at(:user_id)) + Post.where(timeline_id: friend_params.values_at(:user_id))).uniq
		respond_with @posts
	end

	def get_newsfeed
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
		respond_with @newsfeed
	end

	def get_related_comments
		@post = Post.find(post_params.values_at(:post_id)).first
		@comments = @post.comments.order("created_at DESC")
		respond_with @comments
	end

	def new_quote
		@post = Post.create() 
		@post.user_id = new_post_params.values_at(:user_id).first
		@post.timeline_id = new_post_params.values_at(:timeline_id).first
		@post.genre = new_post_params.values_at(:genre).first
		@post.book = new_post_params.values_at(:book).first
		@post.author = new_post_params.values_at(:author).first
		@post.content = new_post_params.values_at(:content).first
		#byebug
		@post.save
	end

	def new_review
		@post = Post.create() 
		@post.user_id = new_post_params.values_at(:user_id).first
		@post.timeline_id = new_post_params.values_at(:timeline_id).first
		@post.genre = new_post_params.values_at(:genre).first
		@post.book = new_post_params.values_at(:book).first
		@post.author = new_post_params.values_at(:author).first
		@post.content = new_post_params.values_at(:content).first
		byebug
		@post.save
	end

	def new_status
		@post = Post.create() 
		@post.user_id = new_post_params.values_at(:user_id).first
		@post.timeline_id = new_post_params.values_at(:timeline_id).first
		@post.genre = new_post_params.values_at(:genre).first
		@post.book = new_post_params.values_at(:book).first
		@post.author = new_post_params.values_at(:author).first
		@post.content = new_post_params.values_at(:content).first
		byebug
		@post.save
	end

protected
  
  	def post_params
    	params.require(:post).permit(:post_id)
 	end

 	def new_post_params
    	params.require(:post).permit(:genre , :user_id , :timeline_id, :book , :author ,:content)
 	end

 	def friend_params
 		params.require(:user).permit(:user_id)
 	end

end
