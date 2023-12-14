class AddDeleteToAssistants < ActiveRecord::Migration[7.1]
  def change
    add_column :assistants, :deleted, :boolean, default: false
  end
end
