# frozen_string_literal: true

require 'rails_helper'

describe DecorateMovieWithExternalInformations do
  subject { described_class.call(movie) }

  before do
    allow(Clients::Apis::V1::Pairguru).to receive(:get_movie_by_title).and_return(client_return_result)
  end

  let(:movie) { create(:movie) }

  describe '.call' do
    context 'when movie was not found in pairguru api' do
      let(:expected_cover) { URI.parse('https://example.dev') }
      let(:expected_rating) { 0.0 }
      let(:expected_description) { '' }
      let(:client_return_result) do
        Dry::Monads::Result::Failure.new(
          [404, 'Invalid request']
        )
      end

      it 'returns movie object with default values' do
        expect(subject).to have_attributes(
          cover: URI.parse('https://example.dev'),
          description: '',
          rating: 0.0
        )
        expect(subject).to have_attributes(
          cover: expected_cover,
          description: expected_description,
          rating: expected_rating
        )
      end
    end

    context 'when movie was found in pairguru api' do
      let(:expected_image_path) { '/random.png' }
      let(:expected_cover) { URI.parse('https://example.dev/random.png') }
      let(:expected_rating) { 10.0 }
      let(:expected_description) { 'Very long description' }
      let(:client_return_result) do
        Dry::Monads::Result::Success.new(
          [200, { 'attributes' => {
            'poster' => expected_image_path,
            'rating' => expected_rating,
            'plot' => expected_description
          } }]
        )
      end

      it 'returns movie object with data from pairguru api' do
        expect(subject).to have_attributes(
          cover: expected_cover,
          description: expected_description,
          rating: expected_rating
        )
      end
    end
  end
end
