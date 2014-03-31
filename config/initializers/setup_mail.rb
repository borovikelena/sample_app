#ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.ukr.net",
  :port                 => 465,
  :domain               => "ukr.net",
  :user_name            => "borovik_elena@ukr.net",
  :password             => "ujkjdrjnfnmzyf",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "borovik_elena@ukr.net"
  end
end
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?