# frozen_string_literal: true

# 20231221082258
class AddColumnsForUuidFkPhase1 < ActiveRecord::Migration[7.0]
  TABLES_WITH_FK = {
    user_stories: %i[user_uuid story_uuid]
  }.freeze

  def up
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        add_column table, fk_name, :uuid
      end
    end
  end

  def down
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        remove_column table, fk_name
      end
    end
  end
end
