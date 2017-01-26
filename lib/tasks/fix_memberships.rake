namespace :fix do
  task :memberships => [
    'memberships:all'
  ]

  namespace :memberships do
    task :print_info => [:environment] do
      log.head "Fix user group memberships"
    end

    task :all => [:environment, :print_info] do
      log.section "Fixing indirect membership validity ranges"
      UserGroupMembership.with_past.indirect.where(ancestor_type: "Group", descendant_type: "User").all.each do |membership|
        membership.recalculate_validity_range_from_direct_memberships
        membership.save
        print "."
      end
      log.success "\nFertig."
    end

  end
end