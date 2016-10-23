class Admin::FitmentNotesController < Admin::DashboardController
  before_action :set_fitment_note, only: [:show, :edit, :update, :destroy]


  def index
    @fitment_notes = FitmentNote.includes(:note_variations)
    @fitment_note = FitmentNote.new
    @fitment_parents = FitmentNote.parent_groups
  end

  def show
  end

  def edit
    @fitment_parents = FitmentNote.parent_groups
  end

  def create
    @fitment_note = FitmentNote.new(fitment_note_params)

    if @fitment_note.save
      redirect_to admin_fitment_notes_path, notice: 'Fitment Note was successfully created.'
    else
      render :index
    end
  end

  def update
    if @fitment_note.update(fitment_note_params)
      redirect_to admin_fitment_note_path(@fitment_note), notice: 'Fitment Note was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @fitment_note.destroy
    redirect_to admin_fitment_notes_path, notice: 'Fitment Note was successfully destroyed.'
  end

  private
    def set_fitment_note
      @fitment_note = FitmentNote.find(params[:id])
    end

    def fitment_note_params
      params.require(:fitment_note).permit(:name, :parent_id, :used_for_search)
    end
end
