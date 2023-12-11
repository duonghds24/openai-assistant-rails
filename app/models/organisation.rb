class Organisation < ApplicationRecord
  has_many :members, dependent: :destroy
end
