# frozen_string_literal: true

class Api::V1::GenreSerializer < BaseSerializer
  set_type :genre

  attributes :id, :name

  has_many :movies, links: {
    self: ->(_resource) {
      url_helpers.api_v1_movies_url
    }
  }

  meta do |resource|
    { movies_count: resource.movies.count }
  end
end
