class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer :genre_id
      t.string :name
      t.text :item_detail
      t.integer :price_without_tax
      t.boolean :is_sale_status, null: false, default: true

      t.timestamps
    end
  end
end
