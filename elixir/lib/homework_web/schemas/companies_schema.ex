defmodule HomeworkWeb.Schemas.CompaniesSchema do
  @moduledoc """
  Defines the graphql schema for companies.
  """
  use Absinthe.Schema.Notation

  alias HomeworkWeb.Resolvers.CompaniesResolver

  object :company do
    field(:id, non_null(:id))
    field(:name, :string)
    field(:credit_line, :integer)
    field(:available_credit, :integer)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field(:users, :user) do
      resolve(&CompaniesResolver.users/3)
    end

    field(:transactions, :transaction) do
      resolve(&CompaniesResolver.transactions/3)
    end
  end

  object :company_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      @desc "amount is in cents"
      arg(:amount, non_null(:integer))
      arg(:credit, non_null(:boolean))
      arg(:debit, non_null(:boolean))
      arg(:description, non_null(:string))

      resolve(&CompaniesResolver.create_company/3)
    end

    @desc "Update a company"
    field :update_company, :company do
      arg(:id, non_null(:id))
      arg(:user_id, non_null(:id))
      arg(:merchant_id, non_null(:id))
      @desc "amount is in cents"
      arg(:amount, non_null(:integer))
      arg(:credit, non_null(:boolean))
      arg(:debit, non_null(:boolean))
      arg(:description, non_null(:string))

      resolve(&CompaniesResolver.update_company/3)
    end

    @desc "delete an existing company"
    field :delete_company, :company do
      arg(:id, non_null(:id))

      resolve(&CompaniesResolver.delete_company/3)
    end
  end
end
