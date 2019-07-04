class Assignment < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :user, optional: true
  belongs_to :role, optional: true
  belongs_to :location, optional: true

  before_save :assign_project

  def assign_project
    update_attributes(project: user.projects.last) if project.nil?
  end
end
