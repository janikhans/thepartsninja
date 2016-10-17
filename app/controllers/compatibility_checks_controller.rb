class CompatibilityChecksController < ApplicationController
  before_action :authenticate_user!

  def new
    # Example params for testing
    # http://localhost:3000/compatibility-check?utf8=%E2%9C%93&v_one%5Byear%5D=2004&v_one%5Bbrand%5D=Yamaha&v_one%5Bmodel%5D=Yz250&v_two%5Byear%5D=2010&v_two%5Bbrand%5D=Yamaha&v_two%5Bmodel%5D=yz450f&product%5D=Wheel+Assembly
    @results = []
    if params[:v_one].present?
      v_one = Vehicle.find_with_specs(params[:v_one][:brand],params[:v_one][:model],params[:v_one][:year])
      v_two = Vehicle.find_with_specs(params[:v_two][:brand],params[:v_two][:model],params[:v_two][:year])
      product_type = ProductType.find_by(name: params[:product])
      compatibility_check = CompatibilityCheck.new(vehicle_one_id: v_one.id, vehicle_two_id: v_two.id, product_type_id: product_type.id)
      if compatibility_check.process
          @results = compatibility_check.results
          @parts = compatibility_check.results
          @products = compatibility_check.results.group_by { |s| s.product }
      end
    end
  end

  def results
    @compatibility_check = CompatibilityCheck.new(compatibility_check_params)
    if @compatibility_check.process
        @results = @compatibility_check.results
        @parts = @compatibility_check.results
        @products = @compatibility_check.results.group_by { |s| s.product }
      respond_to :js
    else
      "damn..."
    end
  end

  private

  def compatibility_check_params
    params.require(:compatibility_check).permit(:vehicle_one_id, :vehicle_two_id, :product_type_id)
  end
end
