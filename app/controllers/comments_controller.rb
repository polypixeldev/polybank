class CommentsController < ApplicationController
  COMMENTABLE_TYPE_MAP = [ Transaction ].index_by(&:to_s).freeze

  before_action :set_comment, except: :create

  def create
    commentable = COMMENTABLE_TYPE_MAP[params[:comment][:commentable_type]].find(params[:comment][:commentable_id])

    authorize commentable, :comment?

    commentable.comments.create!(comment_params.merge(author: current_user))

    redirect_back_or_to commentable
  end

  def edit
    authorize @comment
  end

  def update
    authorize @comment

    @comment.update!(comment_params)

    redirect_back_or_to @comment.commentable
  end

  def destroy
    authorize @comment

    @comment.destroy

    redirect_back_or_to @comment.commentable
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :attachment)
  end
end
