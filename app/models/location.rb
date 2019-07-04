class Location < ApplicationRecord
  has_many :assignments
  has_many :projects, -> { distinct }, through: :assignments
  has_many :users, -> { distinct }, through: :assignments

  validates :name, presence: true
end
