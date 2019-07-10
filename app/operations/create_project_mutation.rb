class CreateProjectMutation < Types::BaseMutation
  description "Creates a project"
  argument :name, String, required: true
  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error
  policy UserPolicy, :admin?

  def resolve
    result = Project.create(name: input.name)

    if result.errors.empty?
      {success: result, errors: []}
    else
      {success: false, errors: result.errors.full_messages}
    end
  end
end
