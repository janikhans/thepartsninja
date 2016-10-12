class CompatibilityChecksController < ApplicationController
  before_action :authenticate_user!

  def new
    # @compatibility_check = CompatibilityCheck.new
  end

  def results
    @compatibility_check = CompatibilityCheck.new(compatibility_check_params)
    if @compatibility_check.process
      respond_to :js
    else
      "fuck"
    end
  end

  private

  def compatibility_check_params
    params.require(:compatibility_check).permit(:vehicle_one_id, :vehicle_two_id, :product_type_id)
  end
end
