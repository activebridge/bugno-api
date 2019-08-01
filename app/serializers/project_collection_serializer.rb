# frozen_string_literal: true

class ProjectCollectionSerializer < ApplicationSerializer
  has_many :projects, each_serializer: ProjectSerializer

  def projects
    object
  end
end
