require "openai_assistant"

class AssistantsController < ApplicationController
  before_action :set_assistant, only: %i[show update destroy]

  def index
    @assistants = Assistant.all
    render json: @assistants
  end

  def show
    render json: @assistant
  end

  def create
    @assistant = Assistant.new(assistant_params)
    if @assistant.save
      render json: @assistant, status: :created, location: @assistant
    else
      render json: @assistant.errors, status: :unprocessable_entity
    end
  end

  def update
    if @assistant.update(assistant_params)
      render json: @assistant
    else
      render json: @assistant.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO: just logic delete (add another field to mark this row was called delete) and physical delete in sync action
    # so we no need create new instance for delete action
    if @assistant.assistant_id
      openai_assistant = OpenaiAssistant::Assistant::Client.new(ENV["OPENAI_API_KEY"])
      openai_assistant.delete_assistant(@assistant.assistant_id)
    end
    @assistant.destroy
    render json: { message: "success" }, status: :ok
  end

  def sync
    # create openai assistant client in func sync instead of class variable
    # because in case the openai assistant client error we still can do all action without sync
    openai_assistant = OpenaiAssistant::Assistant::Client.new(ENV["OPENAI_API_KEY"])
    unsynced_assistant = Assistant.where(assistant_id: nil)
    success_sync_assistant = []
    failed_sync_assistant = []
    unsynced_assistant.each do |assistant|
      obj = openai_assistant.create_assistant(assistant.model, assistant.instructions)

      if obj.is_a?(OpenaiAssistant::ErrorResponse)
        # in case of invalid api key, no need to loop anymore
        return render json: { message: "invalid api key" }, status: :internal_server_error if obj.code == "invalid_api_key"

        failed_sync_assistant.push(assistant.id)
      else
        assistant.update(
          assistant_id: obj.id,
          object: obj.object,
          name: obj.name,
          description: obj.description,
          model: obj.model,
          instructions: obj.instructions,
          tools: obj.tools,
          metadata: obj.metadata,
          sync_time: obj.created_at
        )
        success_sync_assistant.push(obj)
      end
    end
    render json: {
      "success_sync_assistant": success_sync_assistant,
      "failed_sync_assistant": failed_sync_assistant
    }, status: :ok
  end

  def clear
    openai_assistant = OpenaiAssistant::Assistant::Client.new("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")
    assistants = openai_assistant.list_assistant
    assistants.each do |assistant|
      openai_assistant.delete_assistant(assistant["id"])
    end
    render json: { message: "cleared" }, status: :ok
  end

  private

  def set_assistant
    @assistant = Assistant.find(params[:id])
  end

  def assistant_params
    params.require(:assistant).permit(:member_id, :name, :description, :model, :instructions,
                                      tools: [])
  end
end
