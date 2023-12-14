class CreateAssistants < ActiveRecord::Migration[7.1]
  def change
    create_table :assistants, id: :uuid do |t|
      t.belongs_to :member, type: :uuid, null: false, foreign_key: true

      t.string :assistant_id
      t.string :object
      t.string :name
      t.string :description
      t.string :model, null: false
      t.string :instructions, null: false
      t.text :tools, array: true, default: []
      t.jsonb :metadata, default: {}
      t.integer :sync_time

      t.timestamps
    end
  end
end
