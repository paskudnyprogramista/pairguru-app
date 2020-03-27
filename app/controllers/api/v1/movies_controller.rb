# frozen_string_literal: true

class Api::V1::MoviesController < Api::V1::BaseController
  def index
    render_serialized_payload { serialize_collection(collection) }
  end

  def show
    render_serialized_payload { serialize_resource(resource) }
  end

  private

  def resource
    Movie.find(params[:id])
  end

  def collection
    Movie.all
  end

  def resource_serializer
    Api::V1::MovieSerializer
  end

  def resource_includes
    %i[genre]
  end
end
