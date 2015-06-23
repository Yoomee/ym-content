class ContentPackageMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"#{Settings.site_name}\" <#{Settings.site_noreply_email}>",
          :bcc => Settings.ym_content_bcc_emails

  def assigned(content_package)
    @content_package = content_package
    mail(:to => @content_package.author.email, :subject => "[#{Settings.site_name}] A piece of content has been assigned to you" )
  end

  def status_changed(content_package)
    @content_package = content_package
    mail(:to => @content_package.author.email, :subject => "[#{Settings.site_name}] A piece of content you are responsible for is now #{@content_package.human_readable_status}" )
  end

end
