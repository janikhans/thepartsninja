class CheckSearchesController < ApplicationController
  before_action :coming_soon
  # before_action :authenticate_user!

  def new
    @search = CheckSearchForm.new
    @brands = Brand.joins(:vehicle_models).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
  end

  # Example params for testing
  # http://localhost:3000/check/results?utf8=%E2%9C%93&search%5Bcategory%5D%5Bname%5D=Brake+pads&search%5Bvehicle%5D%5Bid%5D=1&search%5Bcomparing_vehicle%5D%5Bid%5D=11
  # add fitment_note_id &search%5Bfitment_note%5D%5Bid%5D=3

  def results
    respond_to do |format|
      if params[:search].present?
        @search = CheckSearchForm.new(search_params)
        @search.user = current_user
        if @search.save
          @check_search = @search.check_search
          format.html
          format.js
        else
          format.html
          format.js
        end
      else
        format.html { redirect_to check_index_path }
      end
    end
  end

  def show
    @check_search = CheckSearch.find_by(id: params[:id])
    @check_search.process(query_params.merge(eager_load: true))
    respond_to :js
  end

  private

  def search_params
    params.require(:search).permit(category: [:name, :id], fitment_note: :id, vehicle: [:brand, :model, :year, :id], comparing_vehicle: [:brand, :model, :year, :id])
  end

  def query_params
    whitelist = [:page]
    whitelist.select { |param| params.has_key?(param) }.reduce({}) do |query_params, param|
      query_params.merge({ param => params[param] })
    end
  end
end
