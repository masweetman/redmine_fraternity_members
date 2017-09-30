class ConvertDatabaseToUtf8mb4 < ActiveRecord::Migration
  def change
    # for each table that will store unicode execute:
    execute "ALTER TABLE issues CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE journal_details CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    # for each string/text column with unicode content execute:
    execute "ALTER TABLE issues MODIFY `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE journal_details MODIFY `old_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE journal_details MODIFY `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
  end
end
