# frozen_string_literal: true

class BaseSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id do |resource|
    resource.id.to_s
  end

  class << self
    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
