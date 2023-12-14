require "rails_helper"

RSpec.describe Assistants::API, type: :request do
  describe "GET /api/v1/assistants" do
    it "returns a list of assistants" do
      member = create(:member, role: "admin")
      create_list(:assistant, 3, member: member)

      get "/api/v1/assistants", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it "returns an empty array" do
      member = create(:member, role: "admin")

      get "/api/v1/assistants", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "GET /api/v1/assistants/:id" do
    it "returns an assistant" do
      member = create(:member, role: "admin")
      assistant = create(:assistant, member: member)

      get "/api/v1/assistants/#{assistant.id}", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["id"]).to eq(assistant.id)
    end

    it "returns an error" do
      member = create(:member, role: "admin")

      get "/api/v1/assistants/invalid_id", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(404)
    end
  end
end
