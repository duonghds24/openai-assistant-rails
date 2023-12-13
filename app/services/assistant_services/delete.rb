module AssistantServices
  class Delete < Base
    def call(assistant_id)
      assistant = Assistant.find(assistant_id)
      assistant.update(deleted: true)
    end
  end
end
