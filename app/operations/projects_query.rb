class ProjectsQuery < Types::BaseResolver
  description "Gets all projects for current user"
  type [Outputs::ProjectType], null: true
  policy ProjectPolicy, :view?

  def authorized_resolve
    current_user.projects.tap { |project| authorize project }
  end
end
