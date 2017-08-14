class AddCacheCounters < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :share_count, :integer, default: 0
    add_column :tags, :notes_count, :integer, default: 0
  end
end
