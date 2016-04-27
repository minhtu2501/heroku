class CommentsController < ApplicationController
	before_filter :logged_in_user, only: [:create, :destroy]


	def new
  		@micropost = Micropost.find(params[:micropost_id])
    	@comment = Comment.new(parent_id: params[:parent_id])
	end


	def create
		if params[:parent_id].nil?
			@micropost = Micropost.find(params[:micropost_id])
			@comment = Comment.new(reply_params)
			@comment.micropost = @micropost
			@comment.user = current_user
		else
			@micropost = Micropost.find(params[:micropost_id])
			@comment = Comment.new(comment_params)
			@comment.micropost = @micropost
			@comment.user = current_user
		end

		if @comment.save
			redirect_to request.referrer || current_user
		else				
			flash[:danger] = "Comment fail. Please try again!"
			redirect_to request.referrer || current_user
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		flash[:success] = "Comment has deleted!"
		redirect_to request.referrer || root_path
	end

	private

	def comment_params
		params.require(:comment).permit(:content)
	end

	def reply_params
		params.require(:comment).permit(:parent_id, :content)
	end
end
