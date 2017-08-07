class User < ApplicationRecord
  rolify strict: true
  rolify after_add: :remove_previous_role_if_exists
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :shares, class_name: 'Role', foreign_key: :provider_id, primary_key: :id
  has_many :notes

  ROLES = {
    owner: 'Owner',
    reader: 'Read Only',
    editor: 'Editor'
  }.freeze

  def name
    email.split('@').first.titleize
  end

  private

  def remove_previous_role_if_exists(role)
    roles.where(resource_id: role.resource_id).where.not(name: role.name).destroy_all
  end
end
