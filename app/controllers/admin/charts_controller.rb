# Endpoints for chart data used in admin area
class Admin::ChartsController < Admin::ApplicationController
  def searches_by_type
    result = SearchRecord.group(:searchable_type).count
    render json: [{ name: 'Count', data: result }]
  end

  def search_records
    render json: SearchRecord.group_by_day(:created_at).count
  end

  def vehicles_by_type
    result = VehicleModel.group(:vehicle_type).count
    render json: result.transform_keys(&:name)
  end

  def category_searches
    result = SearchRecord.group(:category_name).limit(10).order(count: :desc).count
    render json: result
  end
end
