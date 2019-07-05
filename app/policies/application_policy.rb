class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def logged_in?
    !user.nil?
  end

  private

  def user_is_admin_or_owns_the_record?
    user.roles.where(name: "Admin").any? || record.users.include?(user)
  end
end
