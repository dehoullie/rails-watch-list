require 'httparty'
class ListsController < ApplicationController

  def index
    @lists = List.all
    @image = image
  end

    def image
    response = HTTParty.get("https://api.unsplash.com/photos/random", {
      query: {
        query: 'movie',
        orientation: 'landscape',
        client_id: 'Xhtgc7vuCbV7SyimEvJxEjKWHXLJaqbvxlGOUutu6H4'
      }
    })

    image_url = response["urls"]["regular"]
    return image_url
  end

  def show
    @list = List.find(params[:id])
    @movies = @list.bookmarks.includes(:movie).map(&:movie)
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

end
