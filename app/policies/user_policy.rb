class UserPolicy < ApplicationPolicy
  def admin?
    return false if user.nil?
    user.roles.where(name: "Admin").any?
  end

  def manage?
    return false if user.nil?
    user.roles.where(name: "Admin").any? || user == record
  end

  alias view? manage?
end
