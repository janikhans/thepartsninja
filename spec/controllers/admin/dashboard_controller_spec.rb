require 'rails_helper'

RSpec.describe Admin::DashboardController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET leads" do
    it "returns http success" do
      get :leads
      expect(response).to be_success
    end
  end

end
