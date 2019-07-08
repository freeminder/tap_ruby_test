require "rails_helper"

describe "Role Query API", :graphql do
  describe "role" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          role(id: $id) {
            id
            name
          }
        }
      GRAPHQL
    end

    it "gets the specified role assigned to current user" do
      user = create(:user)
      role = create(:role, name: Faker::Job.position)
      project = create(:project)
      create(:assignment, user: user, project: project, assignable_type: "Role", assignable_id: role.id)

      result = execute query, as: user, variables: {id: role.id}

      role_result = result[:data][:role]
      expect(role_result[:id]).not_to be(nil)
      expect(role_result[:id]).to eq(role.id.to_s)
    end

    it "gets the role not assigned to current user(not Admin)" do
      user1 = create(:user)
      user2 = create(:user)

      role = create(:role, name: "User")
      project = create(:project)
      create(:assignment, user: user2, project: project, assignable_type: "Role", assignable_id: role.id)

      result = execute query, as: user1, variables: {id: role.id}

      expect(result[:data][:role]).to be(nil)
      expect(result[:errors][0][:extensions][:code]).to eq("UNAUTHORIZED")
    end

    it "gets the role not assigned to current user(Admin)" do
      user1 = create(:user)
      user2 = create(:user)

      role = create(:role, name: "User")
      role_admin = create(:role, name: "Admin")
      project = create(:project)
      create(:assignment, user: user1, project: project, assignable_type: "Role", assignable_id: role.id)
      create(:assignment, user: user2, project: project, assignable_type: "Role", assignable_id: role_admin.id)

      result = execute query, as: user2, variables: {id: role.id}

      role_result = result[:data][:role]
      expect(role_result[:id]).not_to be(nil)
      expect(role_result[:id]).to eq(role.id.to_s)
    end
  end
end
