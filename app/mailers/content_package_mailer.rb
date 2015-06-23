class ContentPackageMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"#{Settings.site_name}\" <#{Settings.site_noreply_email}>",
          :bcc => Settings.ym_content_bcc_emails

  def assigned(content_package)
    @content_package = content_package
    @user = @content_package.author
    mail(:to => @user.email, :subject => "[#{Settings.site_name}] A piece of content has been assigned to you" )
  end

end
