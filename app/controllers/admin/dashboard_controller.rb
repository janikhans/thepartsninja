class Admin::DashboardController < ApplicationController
  include Admin
  before_action :admin_only
  layout "admin_dashboard"

  def index
    @recent_leads = Lead.where(created_at: (Time.now - 24.hours)..Time.now).count
    @recent_searches = Search.where(created_at: (Time.now - 24.hours)..Time.now).count
    @recent_users = User.where(created_at: (Time.now - 24.hours)..Time.now).count
    @recent_discoveries = Discovery.where(created_at: (Time.now - 24.hours)..Time.now).count
    @parts_with_imported_fitments = Part.where(ebay_fitments_imported: true).count
    @user_count = User.count
    @discovery_count = Discovery.count
    @part_count = Part.count
    @brand_count = Brand.count
    @product_count = Product.count
    @vehicle_count = Vehicle.count
    @fitment_count = Fitment.count
    @category_count = Category.count
    @product_type_count = ProductType.count
    @part_attribute_count = PartAttribute.count
    @part_attribution_count = PartAttribution.count
    @fitment_note_count = FitmentNote.count
    @fitment_notation_count = FitmentNotation.count
    @vehicle_model_count = VehicleModel.count
    @vehicle_submodel_count = VehicleSubmodel.count
    @vehicle_year_count = VehicleYear.count
    @vehicle_type_count = VehicleType.count
    @step_count = Step.count
    @compatibilities_count = Compatibility.count
    @profile_count = Profile.count
    @search_count = Search.count
    @lead_count = Lead.count
    @vote_count = ActsAsVotable::Vote.count
    @total_records = @fitment_count + @brand_count + @product_count + @category_count + @part_count + @part_attribution_count +
      @part_attribute_count + @vehicle_model_count + @vehicle_type_count + @vehicle_submodel_count + @vehicle_count + @vehicle_year_count +
      @discovery_count + @step_count + @compatibilities_count + @user_count + @profile_count + @search_count + @lead_count + @vote_count +
      @product_type_count + @fitment_note_count + @fitment_notation_count
    @percentage_imported = (@parts_with_imported_fitments / @part_count.to_f) * 100
    @average_fitment_count = (@fitment_count / @parts_with_imported_fitments.to_f ).floor
  end
end
