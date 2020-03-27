# frozen_string_literal: true

class Clients::Apis::V1::Pairguru
  CONECTION_TIMEOUT = 5
  API_VERSION = 'v1'
  MOVIES_ENDPOINT = 'movies'

  class << self
    include Dry::Monads[:try, :result]

    def get_movie_by_title(title)
      url = movie_api_url(title: title)

      get_movie(url).bind do |http_response|
        check_code(http_response.code).bind do
          decode_payload(http_response.code, http_response.body)
        end
      end
    end

    def get_movies
      # TODO: Impl later as there's no endpoint available for getting list from external api ATM :/
    end

    private

    def get_movie(url)
      result = Try(HTTP::ConnectionError, HTTP::TimeoutError) { client.get(url) }

      if result.success?
        Success(result.value!)
      else
        Failure('Could not fetch data from external service')
      end
    end

    def client
      @client ||= HTTP.timeout(CONECTION_TIMEOUT)
    end

    def movie_api_url(title:)
      URI.join("#{movies_api_url}/", URI.escape(title).to_s)
    end

    def movies_api_url
      URI.join("#{pairguru_base_api_url}/#{API_VERSION}/#{MOVIES_ENDPOINT}")
    end

    def pairguru_base_api_url
      ENV.fetch('PAIRGURU_BASE_API_URL')
    end

    def decode_payload(code, body)
      decoded_response_payload = JSON.parse(body)

      Success[code, decoded_response_payload['data']]
    end

    # rubocop:disable Metrics/MethodLength
    def check_code(code)
      case code
      when 200...300
        Success()
      when 301, 302, 303, 307
        Failure[code, 'Redirect']
      when 401
        Failure[code, 'Unauthorized']
      when 429
        Failure[code, 'Rate limit exceeded']
      when 304, 400, 402...500
        Failure[code, 'Invalid request']
      when 500...600
        Failure[code, 'Server error']
      else
        Failure[code, 'Unknown error']
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
