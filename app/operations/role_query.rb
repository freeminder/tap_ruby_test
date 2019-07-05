class RoleQuery < Types::BaseResolver
  description "Gets the specified role"
  argument :id, ID, required: true
  type Outputs::RoleType, null: true
  policy RolePolicy, :view?

  def authorized_resolve
    Role.find(input.id).tap { |role| authorize role }
  end
end
