module Outputs
  class ProjectType < Types::BaseObject
    implements Types::ActiveRecord

    field :id, ID, null: false
    field :name, String, null: false
    field :users, [Outputs::UserType], null: true
    field :roles, [Outputs::RoleType], null: true
    field :locations, [Outputs::LocationType], null: true
  end
end
