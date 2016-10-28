class Admin::FitmentNotes::SearchNotesController < Admin::DashboardController
  def index
    @query = params[:q]
    if @query
      @note = FitmentNote.find_by(name: @query)
      fitments = Fitment.where("note ilike ?", "%#{@query}%")#.joins(:fitment_notes).where.not("fitment_notes.id = ?", note.id)
    else
      fitments = Fitment.where("note IS NOT NULL")
    end
    @fitments = fitments.includes(:fitment_notes, part: :product).page(params[:page])
    @fitment_count = fitments.count
    @note_counts = seperate_terms(fitments)
    # binding.pry
  end

  private

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
