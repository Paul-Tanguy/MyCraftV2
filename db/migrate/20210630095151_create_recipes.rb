class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :materials
      t.float :quantity
      t.string :extra
      t.integer :priority
      t.text :image
      t.string :mod
      t.string :machine

      t.timestamps
    end
  end
end
