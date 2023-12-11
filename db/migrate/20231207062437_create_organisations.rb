class CreateOrganisations < ActiveRecord::Migration[7.1]
  def change
    create_table :organisations, id: :uuid do |t|
      t.string :org_name

      t.timestamps
    end
  end
end
