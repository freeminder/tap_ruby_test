module Outputs
  class UserType < Types::BaseObject
    implements Types::ActiveRecord

    field :id, ID, null: false
    field :email, String, null: false
    field :name, String, null: false
  end
end
