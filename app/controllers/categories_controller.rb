class CategoriesController < ApplicationController
  before_action :set_category

  def leaves
    render json: @category.descendants.leaves.searchable, only: [:id, :name]
  end

  def subcategories
    @subcategories = @category.children
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
