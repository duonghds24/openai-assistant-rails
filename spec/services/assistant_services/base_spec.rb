require "rails_helper"

RSpec.describe AssistantServices::Base do
  subject { described_class.new }

  describe "#call" do
    it "raises NotImplementedError" do
      expect { subject.call }.to raise_error(NotImplementedError, "AssistantServices::Base must implement the 'call' method.")
    end
  end
end
