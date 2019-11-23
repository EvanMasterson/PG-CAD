class EmailNotifier
  def update(user, storage, file)
    if user && storage && file
      NotificationMailer.send_mail(user, storage, file).deliver_now
    end
  end
end