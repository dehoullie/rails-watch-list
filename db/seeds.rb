# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Destroy all existing records to ensure a clean slate
Movie.destroy_all
# Movie.create(title: "Wonder Woman 1984", overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9)
# Movie.create(title: "The Shawshank Redemption", overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7)
# Movie.create(title: "Titanic", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9)
# Movie.create(title: "Ocean's Eight", overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0)


require 'uri'
require 'net/http'

url = URI("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'
request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNDFlYWI5NDI3OTg1ODg2YzIxOTZhZmVhYjgyMzVhNyIsIm5iZiI6MTc0NjYxOTg2NC42Niwic3ViIjoiNjgxYjRkZDhkMWI5ZTZmODE3YzY5OTdmIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.PDvi62m9cY4pYVeq_f85FoTQm1_hYrmPXT7YMIf-B-s'

response = http.request(request)
top_list = JSON.parse(response.body)
top_list["results"].each do |movie|
  Movie.create(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/original#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )
end

puts Movie.count
