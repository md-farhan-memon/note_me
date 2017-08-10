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

  def update_tags(list)
  end

  private

  def assign_owner
    user.add_role(:owner, self)
  end
end
