module Outputs
  class RoleType < Types::BaseObject
    implements Types::ActiveRecord

    field :id, ID, null: false
    field :name, String, null: false
    field :projects, [Outputs::ProjectType], null: true
    field :users, [Outputs::UserType], null: true
  end
end
