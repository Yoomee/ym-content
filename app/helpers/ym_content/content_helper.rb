module YmContent::ContentHelper

  def status(status_string)
    case status_string
    when 'published' then 'Published'
    when 'pending' then 'Ready to review'
    else 'Draft'
    end
  end

end