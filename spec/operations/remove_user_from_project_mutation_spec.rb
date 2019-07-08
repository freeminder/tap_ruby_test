require "rails_helper"

describe "Remove User From Project Mutation API", :graphql do
  describe "removeUserFromProject" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: RemoveUserFromProjectInput!) {
          removeUserFromProject(input: $input) {
            success
            errors {
              message
            }
          }
        }
      GRAPHQL
    end

    it "removes user with assigned role and location from project" do
      current_user = create(:user)
      role_admin = create(:role, name: "Admin")
      project = create(:project)
      create(:assignment, user: current_user, project: project, assignable_type: "Role", assignable_id: role_admin.id)

      user = create(:user)
      role = create(:role, name: "User")
      location = create(:location)
      create(:assignment, user: user, project: project, assignable_type: "Role", assignable_id: role.id)
      create(:assignment, user: user, project: project, assignable_type: "Location", assignable_id: location.id)

      result = execute query, as: current_user, variables: {
        input: {
          userId: user.id,
          projectId: project.id,
        },
      }

      expect(result[:data][:removeUserFromProject][:success]).to be(true)
      expect(result[:data][:removeUserFromProject][:errors]).to be_empty
      expect(Assignment.where(project: project, user: user, assignable_type: "Role", assignable_id: role.id)).to be_empty
      expect(Assignment.where(project: project, user: user, assignable_type: "Location", assignable_id: location.id)).to be_empty
    end
  end
end
