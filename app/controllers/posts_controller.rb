class PostsController < ApplicationController

	def create
	    @post = current_user.posts.create(post_params)
	    @post.save
	    redirect_to @post
	end

	def new_quote
		@post = Post.new
	end

	def create_quote
		@post = current_user.posts.create(post_params)
		@post.genre = "quote"
		@post.timeline_id = session[:profile]
		@post.save
		redirect_to :back
	end

	def new_review
		@post = Post.new
	end

	def create_review
		@post = current_user.posts.create(post_params)
		@post.genre = "review"
		@post.timeline_id = session[:profile]
		@post.save
		redirect_to :back
	end	

	def new_status
		@post = Post.new
	end

	def create_status
		@post = current_user.posts.create(post_params)
		@post.content = "N/A"
		@post.genre = "status"
		@post.timeline_id = session[:profile]
		@post.save
		redirect_to :back
	end
	def show
    	@post = Post.find(params[:id])
    	@comments = @post.comments.order("created_at DESC")
  	end

  	def index
    	
  	end

  	def users_posts
  		@posts = Post.find(params[:user_id])
  	end

	private
	  def post_params
	    params.require(:post).permit(:book, :author, :genre, :content)
	  end
end
