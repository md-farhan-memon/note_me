class UsersRole < ApplicationRecord
  self.primary_keys = :user_id, :role_id
  belongs_to :user
  belongs_to :role
end
