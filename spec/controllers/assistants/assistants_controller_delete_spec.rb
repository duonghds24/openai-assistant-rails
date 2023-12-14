require "rails_helper"

RSpec.describe Assistants::API, type: :request do
  describe "DELETE /api/v1/assistants/:id" do
    it "deletes an assistant" do
      member = create(:member, role: "admin")
      assistant = create(:assistant, member: member)

      delete "/api/v1/assistants/#{assistant.id}", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(200)
    end

    it "returns an error" do
      member = create(:member, role: "admin")

      delete "/api/v1/assistants/invalid_id", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(404)
    end

    it "delete failed" do
      member = create(:member, role: "admin")
      assistant = create(:assistant, member: member)
      allow_any_instance_of(Assistant).to receive(:update).and_return(false)
      delete "/api/v1/assistants/#{assistant.id}", headers: { "Authorization" => member.id }
      expect(response).to have_http_status(500)
    end
  end
end