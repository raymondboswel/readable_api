defmodule ReadableApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :image_url, :string

      timestamps()
    end

  end
end
