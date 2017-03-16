class RenameProfileFieldTypesToProfileFields < ActiveRecord::Migration
  def change
    %w(Klammerung).each do |sub_type|
      rename_sti_type :profile_fields, "ProfileFieldTypes::#{sub_type}", "ProfileFields::#{sub_type}"
    end
  end

  # http://stackoverflow.com/a/31762672/2066546
  def rename_sti_type(table_name, old_type, new_type)
    reversible do |dir|
      dir.up { execute "UPDATE #{table_name} SET type = '#{new_type}' WHERE type = '#{old_type}'" }
      dir.down { execute "UPDATE #{table_name} SET type = '#{old_type}' WHERE type = '#{new_type}'"}
    end
  end
end
