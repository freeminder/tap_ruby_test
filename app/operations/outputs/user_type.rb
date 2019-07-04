module Outputs
  class UserType < Types::BaseObject
    implements Types::ActiveRecord

    field :id, ID, null: false
    field :email, String, null: false
    field :name, String, null: false
    field :token, String, null: false
  end
end
