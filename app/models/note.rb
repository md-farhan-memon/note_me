class Note < ApplicationRecord
  resourcify
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy
  self.per_page = 10

  validates_presence_of :title, :body

  scope :drafted, -> { where(shared: false) }
  scope :shared, -> { where(shared: true) }
  scope :recently_modified, -> { order('updated_at desc') }

  after_create :assign_owner

  def tags_list=(value)
    value.downcase.split(',').map(&:squish).uniq.each do |tag|
      next unless tag.present?
      tags << Tag.where(name: tag).first_or_create
    end
  end

  def tags_list
    tags.pluck(:name).join(', ')
  end

  def tags_list_numbered
    tags.map { |tag| "#{tag.name}(#{tag.notes_count})" }.join(', ')
  end

  def update_tags(list)
    new_list = list.downcase.split(',').map(&:squish).uniq
    old_list = tags.pluck(:name)
    common_list = new_list & old_list
    save_tags_list(new_list, old_list, common_list)
  end

  def save_tags_list(new_list, old_list, common_list)
    tags = self.tags
    Tag.where(name: (old_list - common_list)).each { |t| tags.delete(t) }
    (new_list - common_list).each { |tag| tags << Tag.where(name: tag).first_or_create }
  end

  def added_role_to_user?(params, provider_id)
    if (user = User.find_by_email(params[:email].downcase)).present? && user_id != user.id
      remove_previous_role_if_any(user, params[:role])
      add_new_role(user, params[:role], provider_id)
      true
    else
      false
    end
  end

  def remove_previous_role_if_any(user, role)
    previus_role = user.roles.where(resource_id: id).first
    return unless previus_role.present?
    user.remove_role(previus_role.name, self) unless previus_role.name.eql?(role)
  end

  def add_new_role(user, role, provider_id)
    role = user.add_role(role, self)
    role.users_roles.where(user_id: user.id).first.update_column(:provider_id, provider_id)
  end

  def remove_role_from_user(user, role)
    user.remove_role(role, self)
    UsersRole.includes(:role).where(provider_id: user.id, 'roles.resource_id' => id).each do |user_role|
      user_role.user.remove_role(user_role.role.name, self)
    end
  end

  private

  def assign_owner
    user.add_role(:owner, self)
  end
end
