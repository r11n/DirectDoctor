class Speciality < ApplicationRecord
  has_many :speciality_aliases
  has_many :doctors
  scope :latest, -> { order(created_at: :desc) }

  validates :code, :name, presence: true
  accepts_nested_attributes_for :speciality_aliases, allow_destroy: true
end
