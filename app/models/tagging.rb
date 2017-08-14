class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :note

  after_create :increment_count
  after_destroy :decrement_count

  private

  def increment_count
    tag.increment!(:notes_count)
  end

  def decrement_count
    tag.decrement!(:notes_count)
  end
end
