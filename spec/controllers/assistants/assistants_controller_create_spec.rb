require "rails_helper"

RSpec.describe Assistants::API, type: :request do
  describe "POST /api/v1/assistants" do
    it "creates a new assistant" do
      member = create(:member, role: "admin")
      assistant_params = attributes_for(:assistant, member_id: member.id)

      post "/api/v1/assistants", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["member_id"]).to eq(member.id)
    end

    it "create assistant failed by wrong model" do
      member = create(:member, role: "admin")
      assistant_params = attributes_for(:assistant, member_id: member.id, model: "wrong_model")

      post "/api/v1/assistants", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("assistant[model] does not have a valid value")
    end 

    it "insert database error" do
      member = create(:member, role: "admin")
      assistant_params = attributes_for(:assistant, member_id: member.id)
      ast_error = build(:assistant).tap { |assistant| assistant.errors.add(:base, "error") }
      allow(Assistant).to receive(:new).with(assistant_params).and_return(ast_error)

      post "/api/v1/assistants", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(500)
    end

    it "member not found" do
      member = create(:member, role: "admin")
      assistant_params = attributes_for(:assistant, member_id: "member_not_found")

      post "/api/v1/assistants", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(400)
    end
  end
end
