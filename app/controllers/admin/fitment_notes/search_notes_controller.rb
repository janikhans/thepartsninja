class Admin::FitmentNotes::SearchNotesController < Admin::DashboardController
  def index
    @query = params[:q]
    if @query
      fitments = Fitment.where("note ilike ?", "%#{@query}%")
    else
      fitments = Fitment.where("note IS NOT NULL")
    end
    @fitments = fitments.includes(part: :product).page(params[:page])
    @fitment_count = fitments.count
    @note_counts = seperate_terms(fitments)
    # binding.pry
  end

  private

  def seperate_terms(fitments)
    notes = []
    fitments.each do |f|
      fitment_notes = f.note.split("; ")
      notes << fitment_notes
    end

    counts = notes.flatten.each_with_object(Hash.new(0)) { |note, counts| counts[note] += 1 }
      .sort_by { |_key, value| value }.reverse.to_h
  end
end
