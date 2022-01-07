defmodule ReadableApi.Email do
  import Bamboo.Email

  def welcome_email do
    new_email(
      to: "raymondboswel@gmail.com",
      from: "admin@readable.ai",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
