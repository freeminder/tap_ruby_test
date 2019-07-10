class MutationType < Types::BaseObject
  field :invite_user, mutation: InviteUserMutation
  field :create_project, mutation: CreateProjectMutation
  field :add_user_to_project, mutation: AddUserToProjectMutation
  field :remove_user_from_project, mutation: RemoveUserFromProjectMutation
  field :delete_user, mutation: DeleteUserMutation

  field :login, Outputs::UserType, null: true do
    description "Login for users"
    argument :email, String, required: true
    argument :password, String, required: true
  end
  def login(email:, password:)
    user = User.find_for_authentication(email: email)
    return nil unless user

    is_valid_for_auth = user.valid_for_authentication? {
      user.valid_password?(password)
    }
    is_valid_for_auth ? user : nil
  end

  field :token_login, Outputs::UserType, null: true do
    description "JWT token login"
  end
  def token_login
    context[:current_user]
  end

  field :logout, Boolean, null: true do
    description "Logout for users"
  end
  def logout
    if context[:current_user]
      context[:current_user].update(jti: SecureRandom.uuid)
      return true
    end
    false
  end

  field :update_user, Outputs::UserType, null: true do
    description "Update user"
    argument :password, String, required: false
    argument :passwordConfirmation, String, required: false
  end
  def update_user(
    password: context[:current_user] ? context[:current_user].password : "",
    password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ""
  )
    user = context[:current_user]
    return nil unless user
    user.update!(
      password: password,
      password_confirmation: password_confirmation
    )
    user
  end

  field :sign_up, Outputs::UserType, null: true do
    description "Sign up for users"
    argument :email, String, required: true
    argument :password, String, required: true
    argument :passwordConfirmation, String, required: true
    argument :name, String, required: true
  end
  def sign_up(email:, password:, password_confirmation:, name:)
    User.create(
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      name: name
    )
  end

  field :send_reset_password_instructions, Boolean, null: true do
    description "Send password reset instructions to users email"
    argument :email, String, required: true
  end
  def send_reset_password_instructions(email:)
    user = User.find_by_email(email)
    return true unless user
    user.send_reset_password_instructions
    true
  end

  field :reset_password, Boolean, null: true do
    argument :password, String, required: true
    argument :passwordConfirmation, String, required: true
    argument :resetPasswordToken, String, required: true
  end
  def reset_password(password:, password_confirmation:, reset_password_token:)
    user = User.with_reset_password_token(reset_password_token)
    return false unless user
    user.reset_password(password, password_confirmation)
  end
end
