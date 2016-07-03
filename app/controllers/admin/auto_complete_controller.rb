class Admin::AutoCompleteController < Admin::DashboardController
  def update_models
    @brand = Brand.find(params[:brand_id])
    @models = @brand.vehicle_models
  end
end
