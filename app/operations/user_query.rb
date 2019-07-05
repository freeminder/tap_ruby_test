class UserQuery < Types::BaseResolver
  description "Gets the specified user"
  argument :id, ID, required: true
  type Outputs::UserType, null: true
  policy UserPolicy, :view?

  def authorized_resolve
    User.find(input.id).tap { |user| authorize user }
  end
end
