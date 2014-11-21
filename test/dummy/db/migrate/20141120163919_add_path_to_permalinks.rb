class AddPathToPermalinks < ActiveRecord::Migration
  def change
    add_column :permalinks, :full_path, :string
  end
end
