class ProjectQuery < Types::BaseResolver
  description "Gets the specified project"
  argument :id, ID, required: true
  type Outputs::ProjectType, null: true
  policy ProjectPolicy, :view?

  def authorized_resolve
    Project.find(input.id).tap { |project| authorize project }
  end
end
