class CommentsController < ApplicationController

	def create_comment
		@comment = Comment.create(comment_params) 
		@comment.user_id = current_user.id
		@comment.post_id = params[:post_id].to_i
		@comment.save
		redirect_to :back
	end

	private
	  def comment_params
	    params.require(:comment).permit(:post_id, :content)
	  end
end
