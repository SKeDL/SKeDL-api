require "rails_helper"

RSpec.describe AccountController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/account").to route_to("account#create")
    end

    it "routes to #update" do
      expect(put: "/account").to route_to("account#update")
    end

    it "routes to #destroy" do
      expect(delete: "/account").to route_to("account#destroy")
    end
  end
end
