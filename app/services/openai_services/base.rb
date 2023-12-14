module OpenaiServices
  class Base
    def initialize(api_key = "")
      @openai_assistant = OpenaiAssistant::Assistant::Client.new(api_key)
    end

    def call(*args)
      raise NotImplementedError, "#{self.class} must implement the 'call' method."
    end
  end
end
