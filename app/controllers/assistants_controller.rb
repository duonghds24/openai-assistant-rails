require "openai_assistant"

class AssistantsController < ApplicationController
  def index
    service = ::AssistantServices::List.new
    assistants = service.call
    render json: assistants
  end

  def show
    service = ::AssistantServices::Get.new
    assistant = service.call(params[:id])
    render json: assistant
  end

  def create
    service = ::AssistantServices::Create.new
    assistant = service.call(assistant_params)
    if assistant.errors.any?
      render json: assistant.errors, status: :unprocessable_entity
    else
      render json: assistant, status: :created
    end
  end

  def update
    service = ::AssistantServices::Update.new
    assistant = service.call(params[:id], assistant_params)
    if assistant[:valid]
      render json: assistant[:assistant], status: :ok
    else
      render json: assistant[:assistant].errors, status: :unprocessable_entity
    end
  end

  def destroy
    service = ::AssistantServices::Delete.new
    result = service.call(params[:id])
    if result
      render json: { message: "mark assistant deleted successfully" }, status: :ok
    else
      render json: { message: "mark assistant deleted failed" }, status: :internal_server_error
    end
  end

  def sync
    service = OpenaiServices::SyncAssistants.new(ENV["OPENAI_API_KEY"])
    result = service.call
    if result[:error].present?
      render json: { message: result[:error] }, status: :internal_server_error
    else
      render json: result, status: :ok
    end
  end

  private

  def assistant_params
    params.require(:assistant).permit(:member_id, :name, :description, :model, :instructions,
                                      tools: [])
  end
end
