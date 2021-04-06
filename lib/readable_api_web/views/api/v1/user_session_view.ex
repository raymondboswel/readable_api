defmodule ReadableApiWeb.API.V1.UserSessionView do
  use ReadableApiWeb, :view

  def render("auth_success.json", %{token:  token, refresh_token: refresh_token}) do
    %{data: %{
         token: token,
         refresh_token: refresh_token
      }}
  end

  def render("auth_fail.json", %{error_message: error_message}) do
    %{data: %{
         message: error_message
      }}
  end
end
