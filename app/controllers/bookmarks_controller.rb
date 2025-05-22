

class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
  end

  def create
    # print params

    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = List.find(params[:list_id])

    if @bookmark.save
      redirect_to list_path(@bookmark.list), notice: 'Bookmark was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), notice: 'Bookmark was successfully destroyed.'
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id, :list_id)
  end
end
