class Location < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :projects, through: :assignments
  has_many :users, through: :assignments

  validates :name, presence: true, uniqueness: true
end
