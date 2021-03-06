module Outputs
  class UserType < Types::BaseObject
    implements Types::ActiveRecord

    field :id, ID, null: false
    field :email, String, null: false
    field :name, String, null: false
    field :token, String, null: false
    field :projects, [Outputs::ProjectType], null: true
    field :roles, [Outputs::RoleType], null: true
    field :locations, [Outputs::LocationType], null: true
  end
end
