class RemoveUserFromProjectMutation < Types::BaseMutation
  description "Removes the specified user from project"
  argument :user_id, ID, required: true
  argument :project_id, ID, required: true
  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error
  policy UserPolicy, :admin?

  def resolve
    user = User.find(input.user_id)
    project = Project.find(input.project_id)
    authorize project

    if project.remove_user(user)
      {success: true, errors: []}
    else
      {success: false, errors: project.errors}
    end
  end
end
