# Common methods for searcable forms
module SearchableForm
  extend ActiveSupport::Concern

  private

  def find_category(params)
    return nil if params.blank?
    if params[:name].present?
      # Currently set so we're only using the Motrycycle Parts category Category.id => 1
      Category.first.descendants.leaves.where('lower(name) = ?', params[:name].downcase).first
    else
      # return error
    end
  end

  def find_fitment_note(params)
    return nil if params.blank?
    if params[:id].present?
      FitmentNote.find_by(id: params[:id])
    elsif params[:name].present?
      FitmentNote.where('lower(name) = ?', params[:name].downcase).first
    else
      # return error
    end
  end

  def find_vehicle(params)
    return nil if params.blank?
    if params[:id].present?
      Vehicle.find_by(id: params[:id])
    elsif params[:brand].present? && params[:model].present? && params[:year].present?
      Vehicle.find_with_specs(params[:brand], params[:model], params[:year])
    else
      # return error
    end
  end
end
