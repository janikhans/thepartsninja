require 'rails_helper'

RSpec.describe "Leads", :type => :request do
  describe "GET /leads" do
    it "works! (now write some real specs)" do
      get leads_path
      expect(response.status).to be(200)
    end
  end
end
