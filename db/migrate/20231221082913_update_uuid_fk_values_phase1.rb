# frozen_string_literal: true

# 20231221082913
class UpdateUuidFkValuesPhase1 < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    safety_assured do
      execute <<~SQL
        UPDATE user_stories
        SET user_uuid = users.uuid, story_uuid = stories.uuid
        FROM users, stories
        WHERE user_stories.user_id = users.id
          AND user_stories.story_id = stories.id
      SQL
    end
  end

  def down
    safety_assured do
      execute <<~SQL
        UPDATE user_stories
        SET user_uuid = NULL, story_uuid = NULL
      SQL
    end
  end
end
