class EmailNotifier
  def update(email, current_user, unique_url)
    if email && current_user && unique_url
      NotificationMailer.send_mail(email, current_user, unique_url).deliver_now
    end
  end
end