module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: %i[index show]
    before_action :resource, only: %i[voteup votedown]
  end

  def voteup
    return head :forbidden if current_user&.author?(@resource)
    @resource.vote_up(current_user)
    render json: { votes: @resource.votes }
  end

  def votedown
    return head :forbidden if current_user&.author?(@resource)
    @resource.vote_down(current_user)
    render json: { votes: @resource.votes }
  end

  private

  def resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end