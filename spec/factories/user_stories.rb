# frozen_string_literal: true

FactoryBot.define do
  factory :user_story do
    user
    user_uuid { |attrs| attrs.user.reload.uuid }
    story
    story_uuid { |attrs| attrs.story.reload.uuid }
  end
end
