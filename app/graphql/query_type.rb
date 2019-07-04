class QueryType < Types::BaseObject
  field :user, resolver: UserQuery
end
