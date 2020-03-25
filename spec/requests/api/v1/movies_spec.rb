# frozen_string_literal: true

require 'rails_helper'

describe 'API V1 Movies', type: :request do
  let(:genre) { create(:genre) }
  let(:genre_movies) { genre.movies }
  let!(:kill_bill_vol_1_movie) { create(:movie, title: 'Kill Bill vol. 1', genre: genre) }
  let!(:kill_bill_vol_2_movie) { create(:movie, title: 'Kill Bill vol. 2', genre: genre) }
  let(:movies) { [kill_bill_vol_1_movie, kill_bill_vol_2_movie] }

  describe 'movies#index' do
    context 'general' do
      before { get '/api/v1/movies' }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns all movies and included genres' do
        expect(json_response['data'].count).to eq(Movie.count)
        expect(json_response['included'].count).to eq(Genre.count)
      end
    end
  end

  describe 'movies#show' do
    context 'general' do
      let(:expected_data_json) do
        {
          "id": kill_bill_vol_1_movie.id.to_s,
          "type": 'movie',
          "attributes": {
            "id": kill_bill_vol_1_movie.id.to_s,
            "title": kill_bill_vol_1_movie.title
          },
          "relationships": {
            "genre": {
              "data": {
                "id": genre.id.to_s,
                "type": 'genre'
              },
              "links": {
                "self": 'http://example/api/v1/genres'
              }
            }
          }
        }
      end

      let(:expected_included_json) do
        [
          {
            'id': genre.id.to_s,
            'type': 'genre',
            'attributes': {
              'id': genre.id.to_s,
              'name': genre.name
            },
            'relationships': {
              'movies': {
                'data': genre.movies.map do |movie|
                  {
                    'id': movie.id.to_s,
                    'type': 'movie'
                  }
                end,
                'links': {
                  'self': 'http://example/api/v1/movies'
                }
              }
            },
            'meta': {
              'movies_count': genre_movies.count.to_s
            }
          }
        ]
      end

      before { get "/api/v1/movies/#{kill_bill_vol_1_movie.id}" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns movie' do
        expect(json_response['data']).to include_json(expected_data_json)
      end

      it 'returns movie included genres' do
        expect(json_response['included']).to include_json(expected_included_json)
      end
    end
  end
end
