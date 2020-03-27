# frozen_string_literal: true

class Api::V1::GenresController < Api::V1::BaseController
  def index
    render_serialized_payload { serialize_collection(collection) }
  end

  def show
    render_serialized_payload { serialize_resource(resource) }
  end

  private

  def resource
    Genre.find(params[:id])
  end

  def collection
    Genre.all
  end

  def resource_serializer
    Api::V1::GenreSerializer
  end

  def resource_includes
    %i[movies]
  end
end
