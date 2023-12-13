module AssistantServices
  class Base
    def call(*args)
      raise NotImplementedError, "#{self.class} must implement the 'call' method."
    end
  end
end
