class DeleteUserMutation < Types::BaseMutation
  description "Deletes the specified user"
  argument :id, ID, required: true
  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error
  policy UserPolicy, :manage?

  def resolve
    user = User.find(input.id)
    authorize user
    user.destroy

    {success: !User.exists?(user.id), errors: user.errors}
  end
end
