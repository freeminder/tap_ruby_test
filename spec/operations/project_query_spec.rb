require "rails_helper"

describe "Project Query API", :graphql do
  describe "project" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          project(id: $id) {
            id
            name
          }
        }
      GRAPHQL
    end

    it "gets the specified project assigned to current user" do
      user = create(:user)
      project = create(:project)
      create(:assignment, user: user, project: project)

      result = execute query, as: user, variables: {id: project.id}

      project_result = result[:data][:project]
      expect(project_result[:id]).not_to be(nil)
      expect(project_result[:id]).to eq(project.id.to_s)
    end

    it "gets the project not assigned to current user(not Admin)" do
      user1 = create(:user)
      user2 = create(:user)

      role = create(:role, name: "User")
      project1 = create(:project)
      project2 = create(:project)
      create(:assignment, user: user1, project: project1, assignable_type: "Role", assignable_id: role.id)
      create(:assignment, user: user2, project: project2, assignable_type: "Role", assignable_id: role.id)

      result = execute query, as: user2, variables: {id: project1.id}

      expect(result[:data][:project]).to be(nil)
      expect(result[:errors][0][:extensions][:code]).to eq("UNAUTHORIZED")
    end

    it "gets the project not assigned to current user(Admin)" do
      user1 = create(:user)
      user2 = create(:user)

      role = create(:role, name: "User")
      role_admin = create(:role, name: "Admin")
      project1 = create(:project)
      project2 = create(:project)
      create(:assignment, user: user1, project: project1, assignable_type: "Role", assignable_id: role.id)
      create(:assignment, user: user2, project: project2, assignable_type: "Role", assignable_id: role_admin.id)

      result = execute query, as: user2, variables: {id: project1.id}

      project_result = result[:data][:project]
      expect(project_result[:id]).not_to be(nil)
      expect(project_result[:id]).to eq(project1.id.to_s)
    end
  end
end
