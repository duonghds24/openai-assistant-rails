require "rails_helper"

RSpec.describe OpenaiServices::Base do
  subject { described_class.new }

  describe "#call" do
    it "raises NotImplementedError" do
      expect { subject.call }.to raise_error(NotImplementedError, "OpenaiServices::Base must implement the 'call' method.")
    end
  end
end
