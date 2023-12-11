require "rails_helper"

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe "POST #create" do
    it "creates an assistant" do
      expect do
        post :create, params: {
          assistant: {
            member_id: member.id,
            model: "gpt-3.5-turbo",
            instructions: "Test Instructions"
          }
        }
      end.to change(Assistant, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "create invalid model" do
      expect do
        post :create, params: {
          assistant: {
            member_id: member.id,
            model: "gpt-9.9",
            instructions: "Test Instructions"
          }
        }
      end.to change(Assistant, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "create invalid member" do
      expect do
        post :create, params: {
          assistant: {
            member_id: "invalid_member",
            model: "gpt-3.5-turbo",
            instructions: "Test Instructions"
          }
        }
      end.to change(Assistant, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "create missing instructions field" do
      expect do
        post :create, params: {
          assistant: {
            member_id: "invalid_member",
            model: "gpt-3.5-turbo"
          }
        }
      end.to change(Assistant, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
