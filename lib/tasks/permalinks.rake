namespace :permalinks do

  task migrate_to_full_path: :environment do
    puts "Finding root level elements"
    ContentPackage.where(:parent_id => nil).each do |cp|
      set_full_path_for_tree cp
    end

    Permalink.where(:active => false).each do |permalink|
      active_permalink = Permalink.find_by_resource_id_and_resource_type_and_active(permalink.resource_id, permalink.resource_type, true)
      permalink.full_path = active_permalink.full_path.gsub(active_permalink.path, permalink.path)
      permalink.save
    end

  end

end

def set_full_path_for_tree(cp)
  puts "Setting full path for #{cp.name}"
  cp.save if cp.permalink
  ContentPackage.where(:parent_id => cp.id).each do |child|
    set_full_path_for_tree child
  end
end