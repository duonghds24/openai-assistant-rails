require "rails_helper"

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe "PUT #update" do
    it "updates an assistant" do
      assistant = create(:assistant, member: member)
      put :update, params: { id: assistant.id, assistant: { instructions: "You are chicken" } }
      expect(response).to have_http_status(:ok)
      assistant.reload
      expect(assistant.instructions).to eq("You are chicken")
    end

    it "updates invalid id" do
      create(:assistant, member: member)
      expect do
        put :update, params: { id: "invalid_id", assistant: { instructions: "You are chicken" } }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "update db failed" do
      assistant = create(:assistant, member: member)
      allow_any_instance_of(Assistant).to receive(:update).and_return(false)
      put :update, params: { id: assistant.id, assistant: { instructions: "You are chicken" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
