require "rails_helper"

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe "DELETE #destroy" do
    it "delete an assistant" do
      assistant = create(:assistant, member: member)
      delete :destroy, params: { id: assistant.id }
      expect(response).to have_http_status(:ok)
      assistant.reload
      expect(assistant.deleted).to eq(true)
    end

    it "updates invalid id" do
      create(:assistant, member: member)
      expect do
        delete :destroy, params: { id: "invalid_id" }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "update db failed" do
      assistant = create(:assistant, member: member)
      allow_any_instance_of(Assistant).to receive(:update).and_return(false)
      delete :destroy, params: { id: assistant.id }
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
