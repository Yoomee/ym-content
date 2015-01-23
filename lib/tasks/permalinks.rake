namespace :permalinks do

  task migrate_to_full_path: :environment do
    ENV['RAKE_PERMALINK_RUNNING'] = 'true'
    puts "Finding root level elements"

    ActiveRecord::Base.record_timestamps = false
    begin
      Permalink.where(:active => false).each do |p|
        p.full_path = "/#{p.path}"
        p.save
      end
    ensure
      ActiveRecord::Base.record_timestamps = true  # don't forget to enable it again!
    end

    ContentPackage.all.each do |cp|
      p = cp.permalink
      next if p.nil?
      cp.permalinks.create(:active => false, :path => p.path, :full_path => "/#{p.path}")
    end

    ActiveRecord::Base.record_timestamps = false
    begin
      ContentPackage.where(:parent_id => nil).each do |cp|
        set_full_path_for_tree cp
      end
    ensure
      ActiveRecord::Base.record_timestamps = true  # don't forget to enable it again!
    end

    ENV['RAKE_PERMALINK_RUNNING'] = 'false'
  end

end

def set_full_path_for_tree(cp)
  puts "About to set Full path for #{cp.id} - #{cp.name}"
  cp.save if cp.permalink

  ContentPackage.where(:parent_id => cp.id).each do |child|
    set_full_path_for_tree child
  end
end