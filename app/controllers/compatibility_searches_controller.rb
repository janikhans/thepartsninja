# Controller to handle searching for compatibile vehicles using the
# CompatibilitySearch model
class CompatibilitySearchesController < ApplicationController
  before_action :coming_soon

  def new
    @search = CompatibilitySearchForm.new
    @brands = Brand.joins(:vehicle_models)
                   .where('vehicle_models.vehicle_type_id = 1')
                   .select('DISTINCT brands.*')
                   .order(name: :asc)
  end

  # Example params for testing
  # http://localhost:3000/find/results?utf8=%E2%9C%93&search%5Bcategory%5D%5Bname%5D=Brake+Levers&search%5Bvehicle%5D%5Bid%5D=35606

  def results
    respond_to do |format|
      if params[:search].present?
        @search = CompatibilitySearchForm.new(search_params)
        @search.user = current_user
        if @search.save
          @compatibility_search = @search.compatibility_search
          format.html
          format.js
        else
          format.html
          format.js
        end
      else
        format.html { redirect_to find_index_path }
      end
    end
  end

  def show
    @compatibility_search = CompatibilitySearch.find_by(id: params[:id])
    @compatibility_search.process(query_params.merge(eager_load: true))
    respond_to :js
  end

  private

  def search_params
    params.require(:search).permit(category: [:name, :id],
                                   fitment_note: :id,
                                   vehicle: [:brand, :model, :year, :id])
  end

  def query_params
    whitelist = [:page]
    whitelist.select { |param| params.key?(param) }.reduce({}) do |query_params, param|
      query_params.merge(param => params[param])
    end
  end
end
