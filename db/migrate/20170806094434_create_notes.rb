class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.boolean :shared, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :notes, :shared
  end
end
