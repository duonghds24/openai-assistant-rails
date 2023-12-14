require "openai_assistant"
require "pundit"

module Assistants
  class API < Grape::API
    helpers Pundit::Authorization

    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      def authorize_admin!
        authorize request, :admin?
      end

      def validate_member_id(member_id)
        return if Member.exists?(id: member_id)
        error!({ error: "invalid member_id", detail: "member not found" }, 400)
      end

      def current_user
        member_id = request.headers["authorization"]
        Member.find_by(id: member_id)
      end
    end

    resource :assistants do
      before do
        authorize_admin!
      end

      desc "return list of assistants"
      get do
        service = ::AssistantServices::List.new
        service.call
      end

      desc "return assistant by id"
      params do
        requires :id, type: String, desc: "assistant id"
      end
      get ":id" do
        service = ::AssistantServices::Get.new
        service.call(params[:id])
      end

      desc "create assistant"
      params do
        requires :assistant, type: Hash do
          requires :member_id, type: String, allow_blank: false
          requires :model, type: String, values: ["dall-e-3", "davinci", "gpt-3.5-turbo"]
          requires :instructions, type: String, allow_blank: false
        end
      end
      post do
        validate_member_id(params[:assistant][:member_id])
        service = ::AssistantServices::Create.new
        assistant = service.call(params[:assistant])
        if assistant.errors.any?
          error!(assistant.errors, 500)
        else
          assistant
        end
      end

      desc "update assistant"
      params do
        requires :id, type: String, desc: "assistant id"
        requires :assistant, type: Hash do
          optional :model, type: String, values: ["dall-e-3", "davinci", "gpt-3.5-turbo"]
        end
      end
      put ":id" do
        service = ::AssistantServices::Update.new
        assistant = service.call(params[:id], params[:assistant])
        if assistant[:valid]
          assistant[:assistant]
        else
          error!(assistant[:assistant].errors, 500)
        end
      end

      desc "delete assistant"
      params do
        requires :id, type: String, desc: "assistant id"
      end
      delete ":id" do
        service = ::AssistantServices::Delete.new
        result = service.call(params[:id])
        if result
          { message: "mark assistant deleted successfully" }
        else
          error!({ message: "mark assistant deleted failed" }, 500)
        end
      end

      desc "sync assistant"
      post :sync do
        service = OpenaiServices::SyncAssistants.new(ENV["OPENAI_API_KEY"])
        result = service.call
        if result[:error].present?
          error!({ message: result[:error] }, 500)
        else
          status :ok
          result
        end
      end
    end
  end
end
