class Admin::StatisticsController < Admin::ApplicationController
  def index
    @recent_leads = Lead.where(created_at: (Time.now - 24.hours)..Time.now).count(:all)
    @recent_searches = Search.where(created_at: (Time.now - 24.hours)..Time.now).count(:all)
    @recent_users = User.where(created_at: (Time.now - 24.hours)..Time.now).count(:all)
    @recent_discoveries = Discovery.where(created_at: (Time.now - 24.hours)..Time.now).count(:all)
    @parts_with_imported_fitments = Part.where(ebay_fitments_imported: true).count(:all)
    @user_count = User.count(:all)
    @discovery_count = Discovery.count(:all)
    @part_count = Part.count(:all)
    @brand_count = Brand.count(:all)
    @product_count = Product.count(:all)
    @vehicle_count = Vehicle.count(:all)
    @fitment_count = Fitment.count(:all)
    @category_count = Category.count(:all)
    @product_type_count = ProductType.count(:all)
    @part_attribute_count = PartAttribute.count(:all)
    @part_attribution_count = PartAttribution.count(:all)
    @fitment_note_count = FitmentNote.count(:all)
    @fitment_notation_count = FitmentNotation.count(:all)
    @vehicle_model_count = VehicleModel.count(:all)
    @vehicle_submodel_count = VehicleSubmodel.count(:all)
    @vehicle_year_count = VehicleYear.count(:all)
    @vehicle_type_count = VehicleType.count(:all)
    @step_count = Step.count(:all)
    @compatibilities_count = Compatibility.count(:all)
    @profile_count = Profile.count(:all)
    @search_count = Search.count(:all)
    @lead_count = Lead.count(:all)
    @vote_count = ActsAsVotable::Vote.count(:all)
    @total_records = @fitment_count + @brand_count + @product_count + @category_count + @part_count + @part_attribution_count +
      @part_attribute_count + @vehicle_model_count + @vehicle_type_count + @vehicle_submodel_count + @vehicle_count + @vehicle_year_count +
      @discovery_count + @step_count + @compatibilities_count + @user_count + @profile_count + @search_count + @lead_count + @vote_count +
      @product_type_count + @fitment_note_count + @fitment_notation_count
    @percentage_imported = (@parts_with_imported_fitments / @part_count.to_f) * 100
    @average_fitment_count = (@fitment_count / @parts_with_imported_fitments.to_f ).floor
  end
end
