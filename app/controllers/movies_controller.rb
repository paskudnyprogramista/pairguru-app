class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  # TODO: Add cache
  def index
    @movies = Movie.find_each(batch_size: 10).map do |movie|
      DecorateMovieWithExternalInformations.call(movie)
    end
  end

  # TODO: Add cache
  def show
    movie = Movie.find(params[:id])

    @movie = DecorateMovieWithExternalInformations.call(movie)
  end

  def send_info
    @movie = Movie.find(params[:id])

    MovieInfoMailer.send_info(current_user, @movie).deliver_now

    redirect_back(fallback_location: root_path, notice: 'Email sent with movie info')
  end

  def export
    file_path = 'tmp/movies.csv'

    MovieExporter.new.call(current_user, file_path)

    redirect_to root_path, notice: 'Movies exported'
  end
end
