class Admin::StatisticsController < Admin::ApplicationController
  def show
    @parts_with_imported_fitments = Part.where(ebay_fitments_imported: true).count(:all)
    @user_count = User.count(:all)
    @discovery_count = Discovery.count(:all)
    @search_record_count = SearchRecord.count
    @part_count = Part.count(:all)
    @brand_count = Brand.count(:all)
    @product_count = Product.count(:all)
    @vehicle_count = Vehicle.count(:all)
    @fitment_count = Fitment.count(:all)
    @category_count = Category.count(:all)
    @ebay_categories_count = EbayCategory.count(:all)
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
    @search_count = SearchRecord.count(:all)
    @lead_count = Lead.count(:all)
    @vote_count = ActsAsVotable::Vote.count(:all)
    @topic_count = ForumTopic.count
    @thread_count = ForumThread.count
    @post_count = ForumPost.count
    @total_records = @fitment_count + @brand_count + @product_count + @category_count + @part_count + @part_attribution_count +
      @part_attribute_count + @vehicle_model_count + @vehicle_type_count + @vehicle_submodel_count + @vehicle_count + @vehicle_year_count +
      @discovery_count + @step_count + @compatibilities_count + @user_count + @profile_count + @search_count + @lead_count + @vote_count +
      @ebay_categories_count + @fitment_note_count + @fitment_notation_count + @topic_count + @thread_count + @post_count + @search_record_count
    @percentage_imported = (@parts_with_imported_fitments / @part_count.to_f) * 100
    @average_fitment_count = (@fitment_count / @parts_with_imported_fitments.to_f ).floor if @parts_with_imported_fitments > 0
  end
end
