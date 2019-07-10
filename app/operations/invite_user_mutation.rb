class InviteUserMutation < Types::BaseMutation
  description "Invites user by email, name, project, role and location"
  argument :email, String, required: true
  argument :name, String, required: true
  argument :project_id, ID, required: true
  argument :role_id, ID, required: true
  argument :location_id, ID, required: true
  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error
  policy UserPolicy, :admin?

  def resolve
    return {success: false, errors: ["User is already invited"]} if User.where(email: input.email).any?
    result = User.invite!(
      email: input.email,
      name: input.name,
      projects: [Project.find(input.project_id)],
      roles: [Role.find(input.role_id)],
      locations: [Location.find(input.location_id)]
    )

    if result
      {success: true, errors: []}
    else
      {success: false, errors: result.errors.full_messages}
    end
  end
end
