# frozen_string_literal: true

[200, 201, 400, 404, 403, 422].each do |status_code|
  shared_examples "returns #{status_code} HTTP status" do
    it "returns #{status_code}" do
      expect(response.status).to eq(status_code)
    end
  end
end
