class MoviesController < ApplicationController

  def show
    @movie = Movie.find(params[:id])
    # Movies on the same list but not the same movie
    # Todo: return another movies with same list 'bookmark'

    list_ids = @movie.bookmarks.select(:list_id)
    @similar_movies = Bookmark.where(list_id: list_ids)
                          .where.not(movie_id: @movie.id)
                          .distinct
                          .sample(3)
                          .pluck(:movie_id)
    @similar_movies = Movie.where(id: @similar_movies)

  end
end
