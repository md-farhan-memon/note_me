class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :shares, class_name: 'Role', foreign_key: :provider_id, primary_key: :id
  has_many :notes

  def name
    email.split('@').first.titleize
  end

  private

  def assign_default_role
    # byebug
    # add_role(:user) if roles.blank?
  end
end
