class Api::CommentsController < Api::BaseController

	def add_comment
		@comment = Comment.create(comment_params) 
		@comment.user_id = comment_params.values_at(:user_id).first
		@comment.post_id = comment_params.values_at(:post_id).first
		@comment.content = comment_params.values_at(:content).first
		@comment.save
	end

protected
  
  	def comment_params
    	params.require(:comment).permit(:post_id, :user_id , :content)
 	end

end