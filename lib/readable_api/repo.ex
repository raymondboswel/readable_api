defmodule ReadableApi.Repo do
  use Ecto.Repo,
    otp_app: :readable_api,
    adapter: Ecto.Adapters.MyXQL
end
