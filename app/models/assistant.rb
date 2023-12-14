class Assistant < ApplicationRecord
  belongs_to :member
  has_one :organisation, through: :member

  validates :model, presence: true,
                    inclusion: { in: ["dall-e-3", "davinci", "gpt-3.5-turbo"], message: "%<value>s is not a valid model" }
  validates :instructions, presence: true
  validates :member_id, presence: true
end
