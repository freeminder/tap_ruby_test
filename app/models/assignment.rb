class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true, optional: true
  belongs_to :project, optional: true
  belongs_to :user

  before_validation(on: :create) do
    if project.nil? && project_id.nil?
      update_attributes(project: user.projects.last)
    elsif project_id
      errors[:project] << "Project does not exist" unless Project.where(id: project_id).any?
    end
  end

  validate :user_already_assigned_to_project?
  validate :role_exists?
  validate :location_exists?

  def user_already_assigned_to_project?
    if project && assignable_type.nil? && Assignment.where(user: user, project: project, assignable_type: nil).any?
      errors[:user] << "User is already assigned to this project"
    end
  end

  def role_exists?
    if assignable_type == "Role" && !assignable_id.nil?
      errors[:role] << "Role does not exist" unless Role.where(id: assignable_id).any?
    end
  end

  def location_exists?
    if assignable_type == "Location" && !assignable_id.nil?
      errors[:location] << "Location does not exist" unless Location.where(id: assignable_id).any?
    end
  end
end
