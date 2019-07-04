class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :assignments, dependent: :destroy
  has_many :projects, -> { distinct }, through: :assignments
  has_many :roles, -> { distinct }, through: :assignments
  has_many :locations, -> { distinct }, through: :assignments

  validates :email, presence: true, uniqueness: true
end
