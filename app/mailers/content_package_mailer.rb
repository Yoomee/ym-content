class ContentPackageMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"#{Settings.site_name}\" <#{Settings.site_noreply_email}>",
          :bcc => ["developers@yoomee.com", "andy@yoomee.com"]

  def assigned(content_package, assigned_to)
    @content_package = content_package
    @user = assigned_to
    reason = @content_package.author.present? ? 'writing' : 'approval'
    @content = "has being assigned to you for #{reason}"
    mail(:to => assigned_to.email, :subject => "[#{Settings.site_name}] #{content_package.name} #{@content}" )
  end

end
