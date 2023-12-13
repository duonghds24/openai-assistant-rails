module AssistantServices
  class Get < Base
    def call(assistant_id)
      Assistant.find(assistant_id)
    end
  end
end
