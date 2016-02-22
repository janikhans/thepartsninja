class LeadsController < ApplicationController

  def create
    @lead = Lead.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
        format.json { render :show, status: :created, location: @lead }
        format.js
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  private

    def lead_params
      params.require(:lead).permit(:email, :auto, :streetbike, :dirtbike, :atv, :utv, :watercraft, :snowmobile, :dualsport)
    end
    
end
