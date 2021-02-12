defmodule Homework.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:available_credit, :integer, default: 0)
      add(:credit_line, :integer, default: 0)
      add(:name, :string, null: false)

      timestamps()
    end
  end
end
