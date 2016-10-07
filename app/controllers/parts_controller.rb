class PartsController < ApplicationController
  before_action :set_part, only: [:show]
  before_action :authenticate_user!

  def show
    @compatibilities = @part.compatibilities
  end

  private
    def set_part
      @part = Part.friendly.find(params[:id])
    end
end
