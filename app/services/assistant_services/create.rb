module AssistantServices
  class Create < Base
    def call(assistant_params)
      assistant = Assistant.new(assistant_params)
      assistant.save
      assistant
    end
  end
end
