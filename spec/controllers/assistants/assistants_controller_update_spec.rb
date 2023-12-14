require "rails_helper"

RSpec.describe Assistants::API, type: :request do
  describe "PUT /api/v1/assistants/:id" do
    it "updates an assistant" do
      member = create(:member, role: "admin")
      assistant = create(:assistant, member: member)

      assistant_params = attributes_for(:assistant, instructions: "new instructions")
      put "/api/v1/assistants/#{assistant.id}", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["instructions"]).to eq("new instructions")
    end

    it "returns an error" do
      member = create(:member, role: "admin")

      assistant_params = attributes_for(:assistant, name: "new name")
      put "/api/v1/assistants/invalid_id", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(404)
    end

    it "update failed" do
      member = create(:member, role: "admin")
      assistant = create(:assistant, member: member)
      allow_any_instance_of(Assistant).to receive(:update).and_return(false)
      assistant_params = attributes_for(:assistant, name: "new name")
      put "/api/v1/assistants/#{assistant.id}", params: { assistant: assistant_params }, headers: { "Authorization" => member.id }
      expect(response).to have_http_status(500)
    end
  end
end
