class Admin::LeadsController < Admin::DashboardController
  before_action :set_lead, only: [:destroy]


   def index
     @leads = Lead.all
   end

   def destroy
     @lead.destroy
     respond_to do |format|
       format.html { redirect_to admin_leads_path, notice: 'Lead was successfully destroyed.' }
       format.json { head :no_content }
     end
   end

   private

     def set_lead
       @lead = Lead.find(params[:id])
     end

 end
