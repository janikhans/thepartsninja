class Admin::AutoCompleteController < Admin::ApplicationController
  def update_models
    @brand = Brand.find(params[:brand_id])
    @models = @brand.vehicle_models
  end
end
