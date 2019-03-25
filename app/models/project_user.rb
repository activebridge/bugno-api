# frozen_string_literal: true

class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
