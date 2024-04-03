# frozen_string_literal: true

class UserStory < ApplicationRecord
  belongs_to :user
  belongs_to :story

  # TODO: After migrations to replace the numeric primary keys
  #   with the corresponding UUID primary key columns, update the
  #   validation lines to validate for :story_uuid and :user_uuid
  validates :story_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :story_id }

  after_create_commit :maintain_uuids

  # TODO: After a migration to replace the numeric foreign keys
  #   with the corresponding UUID FK columns, remove this method.
  def maintain_uuids
    self.user_uuid = user.uuid if user.present?
    self.story_uuid = story.uuid if story.present?
  end
end
