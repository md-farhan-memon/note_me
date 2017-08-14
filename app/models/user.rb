class User < ApplicationRecord
  rolify strict: true,
         after_add: :increment_share_count,
         after_remove: :decrement_share_count
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

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

  def increment_share_count(role)
    role.resource.increment!(:share_count)
  end

  def decrement_share_count(role)
    role.resource.decrement!(:share_count)
  end
end
