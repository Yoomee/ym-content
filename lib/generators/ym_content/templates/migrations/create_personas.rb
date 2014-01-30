class CreatePersonas < ActiveRecord::Migration

  def change
    create_table :personas do |t|
      t.string :name
      t.integer :age
      t.text :summary
      t.text :benefit_1
      t.text :benefit_2
      t.text :benefit_3
      t.text :benefit_4
      t.string :image_uid
      t.string :file_uid
      t.timestamps
    end
    create_table :content_packages_personas, :id => false do |t|
      t.belongs_to :content_package
      t.belongs_to :persona
    end
    add_index :content_packages_personas, :content_package_id
  end

end
