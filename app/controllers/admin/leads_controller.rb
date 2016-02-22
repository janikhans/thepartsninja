class Admin::LeadsController < ApplicationController
  include Admin
  before_action :set_lead, only: [:destroy]
  before_action :admin_only

   def index
     @leads = Lead.all
   end

   def destroy
     @lead.destroy
     respond_to do |format|
       format.html { redirect_to admin_leads_url, notice: 'Lead was successfully destroyed.' }
       format.json { head :no_content }
     end
   end

   private

     def set_lead
       @lead = Lead.find(params[:id])
     end

 end
