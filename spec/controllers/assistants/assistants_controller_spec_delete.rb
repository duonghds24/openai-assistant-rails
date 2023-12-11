require "rails_helper"

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe "DELETE #destroy" do
    it "destroys an assistant" do
      assistant = create(:assistant, member: member)
      expect do
        delete :destroy, params: { id: assistant.id }
      end.to change(Assistant, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end

    it "destroys invalid id" do
      create(:assistant, member: member)
      expect do
        delete :destroy, params: { id: "invalid_id" }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
