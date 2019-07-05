class UsersQuery < Types::BaseResolver
  description "Gets all users"
  type [Outputs::UserType], null: true
  policy UserPolicy, :view?

  def authorized_resolve
    User.all.tap { |user| authorize user }
  end
end
