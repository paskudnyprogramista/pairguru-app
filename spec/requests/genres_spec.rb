require 'rails_helper'

describe 'Genres requests', type: :request do
  before do
    allow(Clients::Apis::V1::Pairguru).to receive(:get_movie_by_title).and_return(
      Dry::Monads::Result::Success.new(
        [200, { 'attributes' => {
          'poster' => expected_image_path,
          'rating' => expected_rating,
          'plot' => expected_description
        } }]
      )
    )
  end

  describe 'genre list' do
    let!(:genres) { create_list(:genre, 5, :with_movies) }
    let(:expected_rating) { '3.0' }
    let(:expected_image_path) { '/random.jpg' }
    let(:expected_description) { 'Very long description' }

    it 'displays only related movies' do
      visit '/genres/' + genres.sample.id.to_s + '/movies'

      expect(page).to have_text("Rating: #{expected_rating}")
      expect(page).to have_text(expected_description)
      expect(page).to have_selector('table tr', count: 5)
    end
  end
end
