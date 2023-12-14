class AddRoleToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :role, :string, default: "member"
  end
end
