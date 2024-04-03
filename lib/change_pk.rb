# frozen_string_literal: true

module ChangePK
  extend ActiveRecord::ConnectionAdapters::DatabaseStatements

  def change_pk(table)
    safety_assured do
      execute "ALTER TABLE #{table} DROP CONSTRAINT IF EXISTS #{table}_pkey;"
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end
  end
end
