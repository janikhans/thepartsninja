class Admin::SearchRecordsController < Admin::ApplicationController
  def index
    @search_records = SearchRecord.includes(:category, :user,
      vehicle: [:vehicle_year, vehicle_submodel: {vehicle_model: :brand}],
      comparing_vehicle: [:vehicle_year, vehicle_submodel: {vehicle_model: :brand}])
      .page(params[:page])
  end

  def destroy
    search_record = SearchRecord.find(params[:id])
    search = search_record.searchable
    search.destroy
    redirect_to admin_search_records_path, notice: 'Search Record was successfully destroyed.'
  end
end
