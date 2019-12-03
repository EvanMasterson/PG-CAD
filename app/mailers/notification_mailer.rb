class NotificationMailer < ApplicationMailer
  def send_mail(email, current_user, unique_url)
    @email = email
    @unique_url = unique_url
    @current_user = current_user
    if @email && @current_user && @unique_url
      mail(to: @email, subject: 'File Shared', template_path: 'layouts', template_name: 'file_shared_notification')
    end
  end
end