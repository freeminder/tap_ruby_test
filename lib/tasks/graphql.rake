require "graphql/rake_task"

GraphQL::RakeTask.new(
  dependencies: [:environment],
  schema_name: "TapRubySchema",
  directory: "app/graphql"
)
