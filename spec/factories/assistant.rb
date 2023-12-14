FactoryBot.define do
  factory :assistant do
    association :member
    model { "gpt-3.5-turbo" }
    instructions { "Make me a sandwich" }
  end
end
