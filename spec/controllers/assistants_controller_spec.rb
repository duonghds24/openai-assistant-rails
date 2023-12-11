require "openai_assistant"
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
  end
end

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

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe "POST #sync" do
    let(:openai_assistant) { instance_double(OpenaiAssistant::Assistant::Client) }

    before do
      allow(OpenaiAssistant::Assistant::Client).to receive(:new).and_return(openai_assistant)
    end

    context "when there are unsynced assistants" do
      DatabaseCleaner.clean_with(:truncation)
      FactoryBot.reload
      let!(:assistant1) { create(:assistant, assistant_id: nil) }
      let!(:assistant2) { create(:assistant, assistant_id: nil) }
      let!(:assistant3) { create(:assistant, assistant_id: "abcdef") }
      let!(:time_now) { Time.now }
      let(:success_sync_assistant) { [] }
      let(:failed_sync_assistant) { [] }

      before do
        allow(openai_assistant).to receive(:create_assistant).and_return(
          OpenaiAssistant::Mapper::Assistant.new(id: "assistant1_id", object: "assistant", name: "Assistant 1", description: "Assistant 1 description", model: "gpt-3.5-turbo",
                                                 instructions: "Test Instructions", tools: [], metadata: {}, created_at: time_now.utc.iso8601),
          OpenaiAssistant::ErrorResponse.new(code: 400, message: "Invalid model")
        )
      end
      it "creates assistants successfully" do
        post :sync
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
                                                  "success_sync_assistant" => [{
                                                    "id" => "assistant1_id",
                                                    "object" => "assistant",
                                                    "name" => "Assistant 1",
                                                    "description" => "Assistant 1 description",
                                                    "model" => "gpt-3.5-turbo",
                                                    "instructions" => "Test Instructions",
                                                    "tools" => [],
                                                    "metadata" => {},
                                                    "created_at" => time_now.utc.iso8601
                                                  }],
                                                  "failed_sync_assistant" => [assistant2.id]
                                                })
      end
    end

    context "when there are no unsynced assistants" do
      it "returns an empty response" do
        post :sync
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
                                                  "success_sync_assistant" => [],
                                                  "failed_sync_assistant" => []
                                                })
      end
    end
    context "when invalid api key" do
      let!(:assistant1) { create(:assistant, assistant_id: nil) }
      before do
        allow(openai_assistant).to receive(:create_assistant).and_return(
          OpenaiAssistant::ErrorResponse.new(code: "invalid_api_key", message: "Invalid api key")
        )
      end
      it "returns an empty response" do
        post :sync
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end

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
