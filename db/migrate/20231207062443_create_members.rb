class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members, id: :uuid do |t|
      t.belongs_to :organisation, type: :uuid, null: false, foreign_key: true

      t.string :member_name, null: false

      t.timestamps
    end
  end
end
