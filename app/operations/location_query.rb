class LocationQuery < Types::BaseResolver
  description "Gets the specified location"
  argument :id, ID, required: true
  type Outputs::LocationType, null: true
  policy LocationPolicy, :view?

  def authorized_resolve
    Location.find(input.id).tap { |location| authorize location }
  end
end
