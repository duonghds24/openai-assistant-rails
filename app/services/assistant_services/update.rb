module AssistantServices
  class Update < Base
    def call(assistant_id, assistant_params)
      assistant = Assistant.find(assistant_id)
      result = assistant.update(assistant_params)
      {
        assistant: assistant,
        valid: result
      }
    end
  end
end
