class NotificationMailer < ApplicationMailer
  def send_mail(email, file_url)
    @email = email
    @file_url = file_url
    if @email && @file_url
      mail(to: @email, subject: 'File Shared', template_path: 'layouts', template_name: 'file_shared_notification')
    end
  end
end