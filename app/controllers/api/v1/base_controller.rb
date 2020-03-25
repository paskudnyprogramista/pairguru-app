# frozen_string_literal: true

class Api::V1::BaseController < ActionController::API
  CONTENT_TYPE = "application/vnd.api+json"

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def serialize_resource(resource)
    resource_serializer.new(resource, include: resource_includes).serialized_json
  end

  def serialize_collection(collection)
    resource_serializer.new(collection, include: resource_includes).serialized_json
  end

  def render_serialized_payload(status = 200)
    render json: yield, status: status, content_type: CONTENT_TYPE
  end

  # TODO: Check if error message is valid agaist API blueprints
  def render_error_payload(error, status = 422)
    render json: { error: error }, status: status, content_type: CONTENT_TYPE
  end

  def record_not_found
    render_error_payload(:resource_not_found, 404)
  end

  def resource_includes
    []
  end
end
