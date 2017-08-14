class Role < ApplicationRecord
  has_many :users_roles
  has_many :users, through: :users_roles
  has_one :provider, class_name: 'User', foreign_key: :id, primary_key: :provider_id

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
