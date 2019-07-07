class AddUserToProjectMutation < Types::BaseMutation
  description "Adds user with specified role and location to project"
  argument :user_id, ID, required: true
  argument :project_id, ID, required: true
  argument :role_id, ID, required: true
  argument :location_id, ID, required: true
  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error
  policy UserPolicy, :admin?

  def resolve
    result = Assignment.create(user_id: input.user_id, project_id: input.project_id)
    return {success: false, errors: result.errors} if result.errors.any?
    result = Assignment.create(user_id: input.user_id, project_id: input.project_id, assignable_type: "Role", assignable_id: input.role_id)
    return {success: false, errors: result.errors} if result.errors.any?
    result = Assignment.create(user_id: input.user_id, project_id: input.project_id, assignable_type: "Location", assignable_id: input.location_id)

    if result.errors.empty?
      {success: true, errors: []}
    else
      {success: false, errors: result.errors}
    end
  end
end
