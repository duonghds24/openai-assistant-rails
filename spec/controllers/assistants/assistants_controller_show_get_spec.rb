require "rails_helper"

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      assistant = create(:assistant, member: member)
      get :show, params: { id: assistant.id }
      expect(response).to be_successful
    end
  end
end
