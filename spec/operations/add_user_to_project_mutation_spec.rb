require "rails_helper"

describe "Add User To Project Mutation API", :graphql do
  describe "addUserToProject" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: AddUserToProjectInput!) {
          addUserToProject(input: $input) {
            success
            errors {
              message
            }
          }
        }
      GRAPHQL
    end

    it "adds user with specified role and location to project" do
      current_user = create(:user)
      role_admin = create(:role, name: "Admin")
      project = create(:project)
      create(:assignment, user: current_user, project: project, assignable_type: "Role", assignable_id: role_admin.id)

      user = create(:user)
      role = create(:role, name: "User")
      location = create(:location)

      result = execute query, as: current_user, variables: {
        input: {
          userId: user.id,
          projectId: project.id,
          roleId: role.id,
          locationId: location.id,
        },
      }

      expect(result[:data][:addUserToProject][:success]).to be(true)
      expect(result[:data][:addUserToProject][:errors]).to be_empty
    end
  end
end
