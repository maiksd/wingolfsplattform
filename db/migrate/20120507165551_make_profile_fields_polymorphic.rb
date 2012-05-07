class MakeProfileFieldsPolymorphic < ActiveRecord::Migration

  def change
    change_table :profile_fields do |t|
      # t.references :profileable, polymorphic: true
      t.rename :user_id, :profileable_id 
      t.string :profileable_type
    end
    
    ProfileField.reset_column_information
    ProfileField.all.each do |pf|
      pf.profileable_type = "User"  # Weil es vorher nur Benutzer gab, die Profilfelder hatten.
      pf.save
    end
  end

end
