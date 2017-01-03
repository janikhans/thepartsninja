class Admin::BulkEditFitmentsController < Admin::ApplicationController
  def index
    fitments = Fitment.all
    @search = params[:search]

    if @search
      if @search[:category_id].present?
        fitments = fitments.joins(part: :product).where('products.category_id = ?', @search[:category_id])
      end
      if @search[:fitment_note_name].present?
        @note = FitmentNote.where('lower(name) = ?', @search[:fitment_note_name].downcase).first
        note_name = @note.try(:name) || @search[:fitment_note_name]
        if @search[:is_exact] == "1"
          fitments = fitments.where('fitments.note like ?', note_name)
        else
          fitments = fitments.where('fitments.note ilike ?', "%#{note_name}%")
        end
        # fitments = fitments.joins(:fitment_notations).where('fitment_notations.fitment_note_id != ?', @note.id) if @note.present? && @search[:note_exists] == "1"
      end
      if @search[:note_status].present?
        fitments = fitments.where(note: nil) if @search[:note_status] == "1"
        fitments = fitments.where.not(note: nil) if @search[:note_status] == "2"
      end
      if @search[:exclude].present?
        @excluded_terms = @search[:exclude].split(",").map(&:strip)
        @excluded_terms.each do |term|
          fitments = fitments.where("note not ilike ?", "%#{term}%")
        end
      end
    end
    @fitments = fitments.includes(:fitment_notes, fitment_notations: :fitment_note, part: :product).page(params[:page]).per(100)
    @fitments_count = fitments.count
    # @note_counts = seperate_terms(fitments)
  end

  def new
    @fitments = Fitment.where(id: fitment_collection_params[:fitment_ids]).includes(part: :product)
    @fitment = Fitment.new
  end

  def create
    @fitments = Fitment.where(id: fitment_collection_params[:fitment_ids])

    @updated_fitments = []
    @fitments.each do |fitment|
      notation = fitment.fitment_notations.build(fitment_note_id: fitment_params[:notations][:fitment_note_id])
      if notation.save
        @updated_fitments << fitment
      end
    end
    if @updated_fitments.count > 0 #update_all(category_id: fitment_params[:category_id])
      redirect_to :back, notice: "#{@updated_fitments.count} Fitments successfully updated"
      # redirect_to admin_product_path(@product.product), notice: 'Product was successfully created.'
    else
      redirect_to :back, alert: "Fitments were unable to be udpated"
      # render :new
    end
  end

  private

  def fitment_collection_params
    params.permit(fitment_ids: [])
  end

  def fitment_params
    params.require(:fitment).permit(notations: [:fitment_note_id])
  end

  def seperate_terms(fitments)
    notes = []
    fitments.each do |f|
      fitment_notes = f.note.split("; ")
      fitment_notes.reject!{ |n| f.fitment_notes.include?(FitmentNote.find_by(name: n)) } # this removes the results that currently have a FitmentNotation
      notes << fitment_notes
    end

    counts = notes.flatten.each_with_object(Hash.new(0)) { |note, counts| counts[note] += 1 }
      .sort_by { |_key, value| value }.reverse.to_h
  end
end
#
# Fitment.where("note ilike ?", "%front").joins(:fitment_notes).where.not("fitment_notes.id = ?", note.id)
# Fitment.joins(:fitment_notations).where("note ilike ? AND fitment_notations.fitment_note_id != ?", "%front", @note.id)
# Fitment.joins(:fitment_notations).where("note ilike ? AND fitment_notations.fitment_note_id = ?", "%front", 3)
# Fitment.where("note ilike ?", "%front")
