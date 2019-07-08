require "rails_helper"

describe "Invite User Mutation API", :graphql do
  describe "inviteUser" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: InviteUserInput!) {
          inviteUser(input: $input) {
            success
            errors {
              message
            }
          }
        }
      GRAPHQL
    end

    it "invites user with specified role and location to project" do
      current_user = create(:user)
      role_admin = create(:role, name: "Admin")
      project = create(:project)
      create(:assignment, user: current_user, project: project, assignable_type: "Role", assignable_id: role_admin.id)

      role = create(:role, name: "User")
      location = create(:location)

      result = execute query, as: current_user, variables: {
        input: {
          email: Faker::Internet.email,
          name: Faker::Name.name,
          projectId: project.id,
          roleId: role.id,
          locationId: location.id,
        },
      }

      expect(result[:data][:inviteUser][:success]).to be(true)
      expect(result[:data][:inviteUser][:errors]).to be_empty
    end
  end
end
