class AddProviderToUsersRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :users_roles, :provider_id, :integer
    remove_column :roles, :provider_id
    add_index(:users_roles, :provider_id)
  end
end
