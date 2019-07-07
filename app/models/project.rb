class Project < ApplicationRecord
  has_many :assignments
  has_many :users, -> { distinct }, through: :assignments
  has_many :roles, through: :assignments, source: :assignable, source_type: "Role"
  has_many :locations, through: :assignments, source: :assignable, source_type: "Location"

  validates :name, presence: true, uniqueness: true

  def remove_user(user)
    Assignment.where(project: self, user: user).destroy_all
  end
end
