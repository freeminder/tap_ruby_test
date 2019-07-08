require "rails_helper"

describe "Location Query API", :graphql do
  describe "location" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          location(id: $id) {
            id
            name
          }
        }
      GRAPHQL
    end

    it "gets the specified location assigned to current user" do
      user = create(:user)
      location = create(:location, name: Faker::Address.city)
      project = create(:project)
      create(:assignment, user: user, project: project, assignable_type: "Location", assignable_id: location.id)

      result = execute query, as: user, variables: {id: location.id}

      location_result = result[:data][:location]
      expect(location_result[:id]).not_to be(nil)
      expect(location_result[:id]).to eq(location.id.to_s)
    end

    it "gets the location not assigned to current user(not Admin)" do
      user1 = create(:user)
      user2 = create(:user)

      location1 = create(:location, name: Faker::Address.city)
      location2 = create(:location, name: Faker::Address.city)
      project = create(:project)
      create(:assignment, user: user1, project: project, assignable_type: "Location", assignable_id: location1.id)
      create(:assignment, user: user2, project: project, assignable_type: "Location", assignable_id: location2.id)

      result = execute query, as: user1, variables: {id: location2.id}

      expect(result[:data][:location]).to be(nil)
      expect(result[:errors][0][:extensions][:code]).to eq("UNAUTHORIZED")
    end

    it "gets the location not assigned to current user(Admin)" do
      user1 = create(:user)
      user2 = create(:user)

      role = create(:role, name: "User")
      role_admin = create(:role, name: "Admin")
      project = create(:project)
      location1 = create(:location, name: Faker::Address.city)
      location2 = create(:location, name: Faker::Address.city)
      create(:assignment, user: user1, project: project, assignable_type: "Role", assignable_id: role.id)
      create(:assignment, user: user1, project: project, assignable_type: "Location", assignable_id: location1.id)
      create(:assignment, user: user2, project: project, assignable_type: "Role", assignable_id: role_admin.id)
      create(:assignment, user: user2, project: project, assignable_type: "Location", assignable_id: location2.id)

      result = execute query, as: user2, variables: {id: location1.id}

      location_result = result[:data][:location]
      expect(location_result[:id]).not_to be(nil)
      expect(location_result[:id]).to eq(location1.id.to_s)
    end
  end
end
