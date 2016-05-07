class CompatiblesController < ApplicationController
  include Admin
  before_action :set_compatible, only: [:show, :upvote, :downvote]
  before_action :authenticate_user!
  before_action :admin_only, only: [:show]

  def show
  end

  def upvote
    if @compatible.upvote_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def downvote
    if @compatible.downvote_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compatible
      @compatible = Compatible.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compatible_params
      params.require(:compatible).permit(:fitment_id, :compatible_fitment_id, :discovery_id, :user_id, :backwards)
    end
end
