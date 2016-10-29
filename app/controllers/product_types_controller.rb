class ProductTypesController < ApplicationController
  def part_attributes
    product_type = ProductType.find(params[:id])
    @part_attributes = product_type.part_attributes.includes(:parent_attribute).order(name: :asc)
    render json: @part_attributes.map { |attribute| {id: attribute.id, name: attribute.name, parent_name: attribute.parent_attribute.name} }
  end

  def fitment_notes
    product_type = ProductType.find(params[:id])
    @fitment_notes = product_type.fitment_notes.includes(:parent_note).order(name: :asc)
    render json: @fitment_notes.map { |note| {id: note.id, name: note.name, parent_name: note.parent_note.name} }
  end
end