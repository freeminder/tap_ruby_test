require "rails_helper"

describe "Login Mutation API", :graphql do
  describe "login" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($email: String!, $password: String!) {
          login(email: $email, password: $password) {
            id
            name
            email
            token
          }
        }
      GRAPHQL
    end

    it "signs in a user" do
      password = Faker::Internet.password
      email = Faker::Internet.email
      user = create(:user, name: Faker::Name.name, email: email, password: password)

      result = execute query, as: nil, variables: {
        email: email,
        password: password,
      }

      expect(result[:data][:login][:id]).to eq(user.id.to_s)
      expect(result[:data][:login][:name]).to eq(user.name)
      expect(result[:data][:login][:email]).to eq(user.email)
      expect(result[:data][:login][:token]).to eq(user.token)
    end
  end
end
