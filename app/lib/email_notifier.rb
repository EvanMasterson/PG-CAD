class EmailNotifier
  def update(email, file_url)
    if email && file_url
      NotificationMailer.send_mail(email, file_url).deliver_now
    end
  end
end