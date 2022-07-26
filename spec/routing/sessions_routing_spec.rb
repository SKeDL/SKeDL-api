require "rails_helper"

RSpec.describe SessionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sessions").to route_to("sessions#index")
    end

    it "routes to #create" do
      expect(post: "/sessions").to route_to("sessions#create")
    end

    it "routes to #show" do
      expect(get: "/sessions/1").to route_to("sessions#show", id: "1")
    end

    it "routes to #update" do
      expect(put: "/sessions").to route_to("sessions#update")
    end

    it "routes to #destroy" do
      expect(delete: "/sessions/1").to route_to("sessions#destroy", id: "1")
    end
  end
end
