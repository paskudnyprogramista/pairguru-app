# frozen_string_literal: true

module Api
  module V1
    module Helpers
      def json_response
        case body = JSON.parse(response.body)
        when Hash
          body.with_indifferent_access
        when Array
          body
        end
      end
    end
  end
end
