class CategoriesController < ApplicationController
  before_action :set_category

  def subcategories
    @subcategories = @category.children
  end

  def part_attributes
    @part_attributes = @category.part_attributes.includes(:parent_attribute).order(name: :asc)
    render json: @part_attributes.map { |attribute| {id: attribute.id, name: attribute.name, parent_name: attribute.parent_attribute.name} }
  end

  def fitment_notes
    @fitment_notes = @category.fitment_notes.includes(:parent_note).order(name: :asc)
    render json: @fitment_notes.map { |note| {id: note.id, name: note.name, parent_name: note.parent_note.name} }
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
