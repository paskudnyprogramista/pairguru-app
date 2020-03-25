# frozen_string_literal: true

require 'rails_helper'

describe 'API V1 Genres', type: :request do
  let!(:action_genre) { create(:genre) }
  let(:action_genre_movies) { action_genre.movies }
  let!(:kill_bill_vol_1_movie) { create(:movie, title: 'Kill Bill vol. 1', genre: action_genre) }

  describe 'genres#index' do
    context 'general' do
      before { get '/api/v1/genres' }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns all genres and included movies' do
        expect(json_response['data'].count).to eq(Genre.count)
        expect(json_response['included'].count).to eq(Movie.count)
      end
    end
  end

  describe 'genres#show' do
    context 'general' do
      let(:expected_data_json) do
        {
          "id": action_genre.id.to_s,
          "type": 'genre',
          "attributes": {
            "id": action_genre.id.to_s,
            "name": action_genre.name
          },
          "relationships": {
            "movies": {
              "data": [{
                "id": kill_bill_vol_1_movie.id.to_s,
                "type": 'movie'
              }],
              "links": {
                "self": 'http://example/api/v1/movies'
              }
            }
          },
          "meta": {
            "movies_count": action_genre_movies.count.to_s
          }
        }
      end

      let(:expected_included_json) do
        action_genre.movies.map do |movie|
          {
            'id': movie.id.to_s,
            'type': 'movie',
            'attributes': {
              'id': movie.id.to_s,
              'title': movie.title
            },
            "relationships": {
              "genre": {
                "data": {
                  "id": action_genre.id.to_s,
                  "type": 'genre'
                },
                "links": {
                  "self": 'http://example/api/v1/genres'
                }
              }
            }
          }
        end
      end

      before { get "/api/v1/genres/#{action_genre.id}" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns genre' do
        expect(json_response['data']).to include_json(expected_data_json)
      end

      it 'returns included movies' do
        expect(json_response['included']).to include_json(expected_included_json)
      end
    end
  end
end
