class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true, optional: true
  belongs_to :project, optional: true
  belongs_to :user, optional: true

  before_validation(on: :create) do
    update_attributes(project: user.projects.last) if project.nil?
  end

  validate :user_already_assigned_to_project?

  def user_already_assigned_to_project?
    if project && assignable_type.nil? && Assignment.where(user: user, project: project, assignable_type: nil).any?
      errors[:user] << "is already assigned to this project"
    end
  end
end
