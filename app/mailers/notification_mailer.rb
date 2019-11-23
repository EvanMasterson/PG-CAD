class NotificationMailer < ApplicationMailer
  def send_mail(user, storage, file)
    @user = user
    @storage = storage
    @file = file
    if @user && @storage && @file
      mail(to: @user.email, subject: 'File Shared', template_path: 'layouts', template_name: 'file_shared_notification')
    end
  end
end