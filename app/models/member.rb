class Member < ApplicationRecord
  belongs_to :organisation
  has_many :assistants
end
