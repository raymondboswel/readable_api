defmodule ReadableApi.Email do
  import Bamboo.Email

  def welcome_email(to, body) do
    new_email(
      to: to,
      from: "admin@readable.ai",
      subject: "Welcome to the Readable!",
      html_body: body,
      text_body: "Thanks for joining!"
    )
  end
end
