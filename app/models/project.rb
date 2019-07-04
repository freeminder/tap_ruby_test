class Project < ApplicationRecord
  has_many :assignments
  has_many :users, -> { distinct }, through: :assignments
  has_many :roles, -> { distinct }, through: :assignments
  has_many :locations, -> { distinct }, through: :assignments

  validates :name, presence: true, uniqueness: true
end
