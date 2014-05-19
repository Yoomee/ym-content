class ContentPackageMailer < ActionMailer::Base

  helper YmCore::UrlHelper

  default :from => "\"#{Settings.site_name}\" <#{Settings.site_noreply_email}>",
          :bcc => ["developers@yoomee.com", "andy@yoomee.com"]

  def assigned(content_package, assigned_to)
    @content_package = content_package
    @user = assigned_to
    reasons = { 'author' => 'writing', 'editor' => 'approval', 'admin' => 'approval' }
    @content = "has being assigned to you for #{reasons[@content_package.author.role]}"
    mail(:to => assigned_to.email, :subject => "[#{Settings.site_name}] #{content_package.name} #{@content}" )
  end

end
