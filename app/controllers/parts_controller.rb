class PartsController < ApplicationController
  before_action :set_part, only: [:show]

  def show
    @compatibles = @part.compats
  end

  private
    def set_part
      @part = Part.find(params[:id])
    end
end
