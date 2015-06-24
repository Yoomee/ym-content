namespace :ym_content do
  desc 'Email assigned authors when content is getting old'
  task expiring: :environment do
    ContentPackage.published.expiring.joins(:author).uniq.find_each do |package|
      ContentPackageMailer.expiring(package).deliver
    end
  end
end
