class RemoveAndAddRestrictiveForeignKeyToBookmarks < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :bookmarks, :movies
    add_foreign_key :bookmarks, :movies, on_delete: :restrict
  end
end
