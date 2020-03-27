# frozen_string_literal: true

class DecorateMovieWithExternalInformations
  class << self
    include Dry::Monads[:result]

    def call(movie)
      result = pairguru_api_client.get_movie_by_title(movie.title)

      # TODO: get_movie_by_title should return always [code, obj]
      # Now, it can return message when exception occur durring connection
      # to external resource. This would eliminate two ifs.
      pairguru_movie = result.success? ? result.success : {}
      context = create_context(pairguru_movie)

      movie.decorate(context: context)
    end

    private

    def create_context(pairguru_movie)
      code, movie = pairguru_movie

      code == 200 ? movie['attributes'] : {}
    end

    def pairguru_api_client
      Clients::Apis::V1::Pairguru
    end
  end
end
