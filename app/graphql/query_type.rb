class QueryType < Types::BaseObject
  field :user, resolver: UserQuery
  field :users, resolver: UsersQuery
  field :project, resolver: ProjectQuery
  field :projects, resolver: ProjectsQuery
  field :role, resolver: RoleQuery
  field :roles, resolver: RolesQuery
  field :location, resolver: LocationQuery
  field :locations, resolver: LocationsQuery
end
