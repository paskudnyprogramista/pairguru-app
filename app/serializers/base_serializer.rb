# frozen_string_literal: true

class BaseSerializer
  include FastJsonapi::ObjectSerializer

  class << self
    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
