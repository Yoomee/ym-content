class CreateSirTrevorImages < ActiveRecord::Migration

  def change
    create_table :sir_trevor_images do |t|
      t.text :image_uid
    end
  end

end
