class ContentPackageMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"#{Settings.site_name}\" <#{Settings.site_noreply_email}>",
          :bcc => Settings.ym_content_bcc_emails

  def assigned(content_package)
    @content_package = content_package
    to = @content_package.author.email
    return unless YmContent.config.permitted_email.call(to)
    mail(:to => to, :subject => "[#{Settings.site_name}] A piece of content has been assigned to you" )
  end

  def expiring(author, content_packages)
    @user = author
    to = @user.try(:email)
    return unless to && YmContent.config.permitted_email.call(to)
    @content_packages = content_packages
    @count = @content_packages.count
    mail(:to => to, :subject => "[#{Settings.site_name}] Some content you are responsible for is getting old" )
  end

  def status_changed(content_package)
    @content_package = content_package
    to = @content_package.author.email
    return unless YmContent.config.permitted_email.call(to)
    mail(:to => to, :subject => "[#{Settings.site_name}] A piece of content you are responsible for is now #{@content_package.human_readable_status}" )
  end

end
