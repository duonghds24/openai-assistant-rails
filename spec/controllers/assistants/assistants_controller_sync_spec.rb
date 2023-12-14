require "rails_helper"
RSpec.describe Assistants::API, type: :request do
  let(:member) { create(:member, role: "admin") }

  describe "POST /api/v1/assistants/sync" do
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
      let!(:assistant4) { create(:assistant, assistant_id: "ghjiod", deleted: true) }
      let!(:assistant5) { create(:assistant, assistant_id: "asdfgh", deleted: true) }
      let!(:time_now) { Time.now }
      let(:success_sync_assistant) { [] }
      let(:failed_sync_assistant) { [] }
      let(:success_deleted_assistant) { [] }

      before do
        allow(openai_assistant).to receive(:create_assistant).and_return(
          OpenaiAssistant::Mapper::Assistant.new(id: "assistant1_id", object: "assistant", name: "Assistant 1", description: "Assistant 1 description", model: "gpt-3.5-turbo",
                                                 instructions: "Test Instructions", tools: [], metadata: {}, created_at: time_now.utc.iso8601),
          OpenaiAssistant::ErrorResponse.new(code: 400, message: "Invalid model")
        )
        allow(openai_assistant).to receive(:delete_assistant).and_return(true,
                                                                         OpenaiAssistant::ErrorResponse.new(code: 400, message: "Invalid model"))
      end
      it "sync assistants successfully" do
        post "/api/v1/assistants/sync", headers: { "Authorization" => member.id }
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
                                                  "failed_sync_assistant" => [assistant2.id, assistant5.id],
                                                  "success_deleted_assistant" => [assistant4.id],
                                                  "error" => nil
                                                })
      end
    end

    context "when there are no unsynced assistants" do
      it "returns an empty response" do
        post "/api/v1/assistants/sync", headers: { "Authorization" => member.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
                                                  "success_sync_assistant" => [],
                                                  "failed_sync_assistant" => [],
                                                  "success_deleted_assistant" => [],
                                                  "error" => nil
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
        post "/api/v1/assistants/sync", headers: { "Authorization" => member.id }
        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context "when deleted api key" do
      let!(:assistant1) { create(:assistant, assistant_id: nil) }
      let!(:assistant2) { create(:assistant, assistant_id: "asdad", deleted: true) }
      before do
        allow(openai_assistant).to receive(:create_assistant).and_return(
          OpenaiAssistant::Mapper::Assistant.new(id: "assistant1_id", object: "assistant", name: "Assistant 1", description: "Assistant 1 description", model: "gpt-3.5-turbo",
                                                 instructions: "Test Instructions", tools: [], metadata: {}, created_at: Time.now)
        )
        allow(openai_assistant).to receive(:delete_assistant).and_return(
          OpenaiAssistant::ErrorResponse.new(code: "invalid_api_key", message: "Invalid api key")
        )
      end
      it "returns an empty response" do
        post "/api/v1/assistants/sync", headers: { "Authorization" => member.id }
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end