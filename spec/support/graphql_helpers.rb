module GraphQLHelpers
  def execute(query, as: nil, context: {}, variables: {})
    context[:current_user] = as unless context.key?(:current_user)
    TapRubySchema.execute(
      query,
      context: context,
      variables: variables.with_indifferent_access
    ).with_indifferent_access
  end
end
