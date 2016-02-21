class LeadsController < ApplicationController

  def create
    @lead = Lead.new(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
        format.json { flash.now = 'Thanks!'}
        format.js
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
        format.js { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:email, interests:[])
    end
end
