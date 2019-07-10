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
    results = []
    results << Assignment.new(user_id: input.user_id, project_id: input.project_id)
    results << Assignment.new(user_id: input.user_id, project_id: input.project_id, assignable_type: "Role", assignable_id: input.role_id)
    results << Assignment.new(user_id: input.user_id, project_id: input.project_id, assignable_type: "Location", assignable_id: input.location_id)

    results.each do |result|
      result.validate
      return {success: false, errors: result.errors.full_messages} if result.errors.any?
    end

    results.each { |result| result.save }
    {success: true, errors: []}
  end
end
