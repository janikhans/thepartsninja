class Admin::LeadsController < Admin::ApplicationController
  before_action :set_lead, only: [:destroy]


   def index
     @leads = Lead.page(params[:page]).order('created_at DESC')
   end

   def destroy
     @lead.destroy
      redirect_to admin_leads_path, notice: 'Lead was successfully destroyed.'
   end

   private

     def set_lead
       @lead = Lead.find(params[:id])
     end
 end
