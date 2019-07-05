class RolesQuery < Types::BaseResolver
  description "Gets all roles for current user"
  type [Outputs::RoleType], null: true
  policy RolePolicy, :view?

  def authorized_resolve
    current_user.roles.tap { |role| authorize role }
  end
end
