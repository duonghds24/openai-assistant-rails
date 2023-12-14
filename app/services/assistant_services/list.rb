module AssistantServices
  class List < Base
    def call
      Assistant.all
    end
  end
end
