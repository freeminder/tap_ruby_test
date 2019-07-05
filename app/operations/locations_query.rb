class LocationsQuery < Types::BaseResolver
  description "Gets all locations for current user"
  type [Outputs::LocationType], null: true
  policy LocationPolicy, :view?

  def authorized_resolve
    current_user.locations.tap { |location| authorize location }
  end
end
