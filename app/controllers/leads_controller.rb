class LeadsController < ApplicationController

  def new
    @lead = Lead.new
    prepare_meta_tags title: "Coming Soon!", description: "The grand release of The Parts Ninja is right around the corner. Until then, sign-up for the newsletter to get early access and updates."
  end

  def create
    @lead = Lead.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  private

    def lead_params
      params.require(:lead).permit(:email, :auto, :streetbike, :dirtbike, :atv, :utv, :watercraft, :snowmobile, :dualsport)
    end
end
