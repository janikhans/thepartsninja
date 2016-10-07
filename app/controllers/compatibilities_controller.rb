class CompatibilitiesController < ApplicationController
  include Admin
  before_action :set_compatibility, only: [:show, :upvote, :downvote]
  before_action :authenticate_user!
  before_action :admin_only, only: [:show]

  def show
  end

  def upvote
    if @compatibility.upvote_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def downvote
    if @compatibility.downvote_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private
    def set_compatibility
      @compatibility = Compatibility.find(params[:id])
    end
end
