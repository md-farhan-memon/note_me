class Note < ApplicationRecord
  resourcify
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings
  self.per_page = 10

  validates_presence_of :title, :body

  scope :drafted, -> { where(shared: false) }
  scope :shared, -> { where(shared: true) }
  scope :date_sorted, -> { order('created_at desc') }

  def tags_list=value
    value.split(',').each do |tag|
      tags.where(name: tag.strip.downcase).first_or_create if tag.present?
    end
  end

  def tags_list
    tags.pluck(:name).join(',')
  end
end
