module OpenaiServices
  class SyncAssistants < Base
    def call
      unsynced_assistant = Assistant.where(assistant_id: nil)
      success_sync_assistant = []
      failed_sync_assistant = []
      success_deleted_assistant = []
      deleted_assistant = Assistant.where(deleted: true)
      unsynced_assistant.each do |assistant|
        obj = @openai_assistant.create_assistant(assistant.model, assistant.instructions)
        if obj.is_a?(OpenaiAssistant::ErrorResponse)
          # in case of invalid api key, no need to loop anymore
          if obj.code == "invalid_api_key"
            return {
              error: "invalid_api_key"
            }
          end
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
      deleted_assistant.each do |assistant|
        obj = @openai_assistant.delete_assistant(assistant.assistant_id)
        if obj.is_a?(OpenaiAssistant::ErrorResponse)
          # in case of invalid api key, no need to loop anymore
          if obj.code == "invalid_api_key"
            return {
              error: "invalid_api_key"
            }
          end
          failed_sync_assistant.push(assistant.id)
        else
          assistant.destroy
          success_deleted_assistant.push(assistant.id)
        end
      end
      {
        success_sync_assistant: success_sync_assistant,
        failed_sync_assistant: failed_sync_assistant,
        success_deleted_assistant: success_deleted_assistant,
        error: nil
      }
    end
  end
end
