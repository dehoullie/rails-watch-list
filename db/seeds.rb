# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'uri'
require 'net/http'

Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

# 1. Fetch all genres and build a hash { id => name }
genre_url = URI("https://api.themoviedb.org/3/genre/movie/list?language=en")
http = Net::HTTP.new(genre_url.host, genre_url.port)
http.use_ssl = true
genre_request = Net::HTTP::Get.new(genre_url)
genre_request["accept"] = 'application/json'
genre_request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNDFlYWI5NDI3OTg1ODg2YzIxOTZhZmVhYjgyMzVhNyIsIm5iZiI6MTc0NjYxOTg2NC42Niwic3ViIjoiNjgxYjRkZDhkMWI5ZTZmODE3YzY5OTdmIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PDvi62m9cY4pYVeq_f85FoTQm1_hYrmPXT7YMIf-B-s'
genre_response = http.request(genre_request)
genres = JSON.parse(genre_response.body)["genres"]
genre_map = genres.each_with_object({}) { |g, h| h[g["id"]] = g["name"] }

# 2. Fetch top rated movies
url = URI("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'
request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNDFlYWI5NDI3OTg1ODg2YzIxOTZhZmVhYjgyMzVhNyIsIm5iZiI6MTc0NjYxOTg2NC42Niwic3ViIjoiNjgxYjRkZDhkMWI5ZTZmODE3YzY5OTdmIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PDvi62m9cY4pYVeq_f85FoTQm1_hYrmPXT7YMIf-B-s'
response = http.request(request)
top_list = JSON.parse(response.body)

top_list["results"].each do |movie|
  m = Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/original#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )

  # 3. For each genre id, create/find the list and associate the movie
  movie["genre_ids"].each do |genre_id|
    genre_name = genre_map[genre_id]
    next unless genre_name
    list = List.find_or_create_by!(name: genre_name)
    # Associate the movie with the list (with a random lorem ipsum comment)
    Bookmark.create!(
      movie: m,
      list: list,
      comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    )
  end
end

puts "Movies: #{Movie.count}"
puts "Lists: #{List.count}"
puts "Bookmarks: #{Bookmark.count}"
