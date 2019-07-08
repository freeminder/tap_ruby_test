require "rails_helper"

describe "Create Project Mutation API", :graphql do
  describe "createProject" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: CreateProjectInput!) {
          createProject(input: $input) {
            success
            errors {
              message
            }
          }
        }
      GRAPHQL
    end

    it "creates a project" do
      user = create(:user)

      result = execute query, as: user, variables: {
        input: {
          name: Faker::Book.title,
        },
      }

      expect(result[:data][:createProject][:success]).to be(true)
      expect(result[:data][:createProject][:errors]).to be_empty
    end
  end
end
