require "rails_helper"

describe "User Query API", :graphql do
  describe "current user" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            id
            name
          }
        }
      GRAPHQL
    end

    it "gets info about self" do
      current_user = create(:user)
      create(:user)

      result = execute query, as: current_user, variables: {id: current_user.id}

      user_result = result[:data][:user]
      expect(user_result[:id]).not_to be(nil)
      expect(user_result[:id]).to eq(current_user.id.to_s)
    end

    it "gets UNAUTHORIZED error when trying to access another user's info" do
      current_user = create(:user)
      user = create(:user)

      result = execute query, as: current_user, variables: {id: user.id}

      expect(result[:data][:user]).to be(nil)
      expect(result[:errors][0][:extensions][:code]).to eq("UNAUTHORIZED")
    end

    it "gets another user's info as Admin" do
      current_user = create(:user)
      user = create(:user)
      role = create(:role, name: "Admin")
      project = create(:project)
      create(:assignment, user: current_user, project: project, assignable_type: "Role", assignable_id: role.id)

      result = execute query, as: current_user, variables: {id: user.id}

      user_result = result[:data][:user]
      expect(user_result[:id]).not_to be(nil)
      expect(user_result[:id]).to eq(user.id.to_s)
    end
  end

  describe "projects" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            projects {
              id
              name
            }
          }
        }
      GRAPHQL
    end

    it "gets all projects for current user" do
      project1 = create(:project)
      project2 = create(:project)

      user1 = create(:user)
      create(:assignment, user: user1, project: project1)

      user2 = create(:user)
      create(:assignment, user: user2, project: project2)

      result = execute query, as: user1, variables: {id: user1.id}

      projects_result = result[:data][:user][:projects][0]
      expect(projects_result[:id]).to eq(project1.id.to_s)
      expect(projects_result[:name]).to eq(project1.name.to_s)
    end
  end

  describe "roles" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            roles {
              id
              name
            }
          }
        }
      GRAPHQL
    end

    it "gets all roles for current user" do
      project = create(:project)

      user1 = create(:user)
      role1 = create(:role, name: "Admin")
      create(:assignment, user: user1, project: project, assignable_type: "Role", assignable_id: role1.id)

      user2 = create(:user)
      role2 = create(:role, name: "User")
      create(:assignment, user: user2, project: project, assignable_type: "Role", assignable_id: role2.id)

      result = execute query, as: user1, variables: {id: user1.id}

      role_result = result[:data][:user][:roles][0]
      expect(role_result[:id]).to eq(role1.id.to_s)
      expect(role_result[:name]).to eq(role1.name.to_s)
    end
  end

  describe "locations" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            locations {
              id
              name
            }
          }
        }
      GRAPHQL
    end

    it "gets all locations for current user" do
      project = create(:project)

      user1 = create(:user)
      location1 = create(:location, name: Faker::Address.city)
      create(:assignment, user: user1, project: project, assignable_type: "Location", assignable_id: location1.id)

      user2 = create(:user)
      location2 = create(:location, name: Faker::Address.city)
      create(:assignment, user: user2, project: project, assignable_type: "Location", assignable_id: location2.id)

      result = execute query, as: user1, variables: {id: user1.id}

      location_result = result[:data][:user][:locations][0]
      expect(location_result[:id]).to eq(location1.id.to_s)
      expect(location_result[:name]).to eq(location1.name.to_s)
    end
  end
end
