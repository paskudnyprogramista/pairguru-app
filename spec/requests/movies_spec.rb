require 'rails_helper'

describe 'Movies requests', type: :request do
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

  describe 'movies list' do
    let(:genre) { create(:genre) }
    let!(:movie) { create(:movie, genre: genre).decorate }
    let(:expected_rating) { '2.0' }
    let(:expected_image_path) { '/random.jpg' }
    let(:expected_description) { 'Very long description' }

    it 'displays right title' do
      visit '/movies'

      expect(page).to have_selector('h1', text: 'Movies')
      expect(page).to have_text("Released: #{movie.release_date}")
      expect(page).to have_text("Rating: #{expected_rating}")
      expect(page).to have_text(expected_description)
      expect(find('.img-rounded')[:src]).to eq("https://example.dev#{expected_image_path}")
    end
  end
end
