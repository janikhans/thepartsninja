require "rails_helper"

RSpec.describe LeadsController, :type => :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "/leads").to route_to("leads#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/leads/1").to route_to("leads#destroy", :id => "1")
    end

  end
end
