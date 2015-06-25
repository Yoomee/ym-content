namespace :ym_content do
  desc 'Email assigned authors when content is getting old'
  task expiring: :environment do
    ContentPackage.published.expiring.includes(:author).uniq.group_by(&:author).each do |author, packages|
      ContentPackageMailer.expiring(author, packages).deliver
    end
  end
end
