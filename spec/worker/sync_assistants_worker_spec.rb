require "rails_helper"

RSpec.describe SyncAssistantsWorker, type: :worker do
  describe "#perform" do
    it "calls the OpenaiServices::SyncAssistants service" do
      expect(OpenaiServices::SyncAssistants).to receive(:new).with(ENV["OPENAI_API_KEY"]).and_return(double(call: {
                                                                                                              "success_sync_assistant": [],
                                                                                                              "failed_sync_assistant": [],
                                                                                                              "success_deleted_assistant": []
                                                                                                            }))
      expect_any_instance_of(SyncAssistantsWorker).to receive(:puts).with("run sync assistants worker")
      expect_any_instance_of(SyncAssistantsWorker).to receive(:puts).with("{\"success_sync_assistant\":[],\"failed_sync_assistant\":[],\"success_deleted_assistant\":[]}")
      expect_any_instance_of(SyncAssistantsWorker).to receive(:puts).with("run sync assistants worker done")

      SyncAssistantsWorker.new.perform
    end

    context "when the OpenaiServices::SyncAssistants service returns an error" do
      it "prints the error message" do
        expect(OpenaiServices::SyncAssistants).to receive(:new).with(ENV["OPENAI_API_KEY"]).and_return(double(call: { error: "Some error message" }))
        expect_any_instance_of(SyncAssistantsWorker).to receive(:puts).with("run sync assistants worker")
        expect_any_instance_of(SyncAssistantsWorker).to receive(:puts).with("sync assistants error")
        expect_any_instance_of(SyncAssistantsWorker).to receive(:puts).with("run sync assistants worker done")

        SyncAssistantsWorker.new.perform
      end
    end
  end
end
