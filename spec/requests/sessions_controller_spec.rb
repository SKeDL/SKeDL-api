require "rails_helper"

RSpec.describe SessionsController, type: :request do
  before(:each) do
    @user = create(:user, username: "test-user", password: "password123")
    @login_data = AuthHelper.login("test-user",
                                   "password123",
                                   Faker::Internet.ip_v4_address,
                                   "user-agent-1") # This creates a session
    @jwt = @login_data[:jwt]
    @sessions = create_list(:session, 5, user: @user)
  end

  describe "GET /sessions" do
    context "with valid JWT" do
      it "returns a success http status" do
        get "/sessions/", headers: { Authorization: "Bearer #{@jwt}" }
        expect(response).to have_http_status(:ok)
      end

      it "renders a json array of sessions" do
        get "/sessions/", headers: { Authorization: "Bearer #{@jwt}" }
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["meta"]["total"]).to eq(6)
        expect(parsed_body["data"][0]["type"]).to eq("session")
      end
    end

    context "with invalid JWT" do
      it "returns a 401 Unauthorized status" do
        get "/sessions/", headers: { Authorization: "Bearer invalid-token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /sessions/:id" do
    context "with valid JWT" do
      it "returns a success http status" do
        get "/sessions/current", headers: { Authorization: "Bearer #{@jwt}" }
        expect(response).to have_http_status(:ok)
      end

      it "renders a json array of sessions" do
        get "/sessions/#{@sessions.first.id}", headers: { Authorization: "Bearer #{@jwt}" }
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["data"]["type"]).to eq("session")
      end
    end

    context "with invalid JWT" do
      it "returns a 401 Unauthorized status" do
        get "/sessions/current", headers: { Authorization: "Bearer invalid-token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /sessions" do
    context "with valid attributes" do
      it "creates a new Sessions" do
        expect {
          post "/sessions",
               params: { username: "test-user", password: "password123" }, as: :json
        }.to change(Session, :count).by(1)
      end

      it "renders required token information" do
        post "/sessions",
             params: { username: "test-user", password: "password123" }, as: :json
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to have_key("AccessToken")
        expect(parsed_body).to have_key("RefreshToken")
        expect(parsed_body).to have_key("ExpireAt")
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new Sessions" do
        expect {
          post "/sessions",
               params: { username: "test-user", password: "invalid" }, as: :json
        }.not_to change(Session, :count)
      end

      it "reutrn status code unauthorized" do
        post "/sessions",
             params: { username: "test-user", password: "invalid" }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /sessions" do
    context "with valid attributes" do
      it "doesn't create a new Sessions" do
        expect {
          put "/sessions",
              headers: { 'User-Agent': "user-agent-1" },
              params: { AccessToken:  @login_data[:jwt],
                        RefreshToken: @login_data[:refresh_token] }, as: :json
        }.not_to change(Session, :count)
      end

      it "renders required Token information" do
        put "/sessions",
            headers: { 'User-Agent': "user-agent-1" },
            params: { AccessToken:  @login_data[:jwt],
                      RefreshToken: @login_data[:refresh_token] }, as: :json

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to have_key("AccessToken")
        expect(parsed_body).to have_key("RefreshToken")
        expect(parsed_body).to have_key("ExpireAt")
      end
    end

    context "with invalid user agent" do
      it "returns a 401 Unauthorized status" do
        put "/sessions", headers: { 'User-Agent': "invalid-user-agent" },
                         params: { AccessToken:  @login_data[:jwt],
                                   RefreshToken: @login_data[:refresh_token] }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid attributes" do
      it "returns a 401 Unauthorized status" do
        put "/sessions", params: { AccessToken: "invalid", RefreshToken: "invalid" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /sessions/:id", type: :request do
    context "with valid JWT Token and session id" do
      it "returns a success HTTP status" do
        delete "/sessions/current", headers: { Authorization: "Bearer #{@jwt}" }
        expect(response).to have_http_status(:success)
      end

      it "marks the session as logged out" do
        session = @sessions.last
        expect(session.logged_out).to be_falsey
        delete "/sessions/#{session.id}", headers: { Authorization: "Bearer #{@jwt}" }
        session.reload
        expect(session.logged_out).to be_truthy
      end
    end

    context "with valid JWT and invalid session Id" do
      it "returns a 404 record not found error" do
        delete "/sessions/invlaid_id", headers: { Authorization: "Bearer #{@jwt}" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with invalid JWT token" do
      it "returns a 401 Unauthorized status" do
        delete "/sessions/current", headers: { Authorization: "Bearer invalid-token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
