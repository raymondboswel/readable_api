defmodule ReadableApi.Repo.Migrations.CreateBookAvailabilityTypes do
  use Ecto.Migration

  def change do
    create table(:book_availability_types) do
      add :availability_type, :string
      add :reference, :string

      timestamps()
    end

  end
end
