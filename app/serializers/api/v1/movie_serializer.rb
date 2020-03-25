# frozen_string_literal: true

class Api::V1::MovieSerializer < BaseSerializer
  set_type :movie

  attributes :id, :title

  belongs_to :genre, links: {
    self: ->(_resource) {
      url_helpers.api_v1_genres_url
    }
  }
end
