class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@ncicloud.live'
  layout 'mailer'
end
