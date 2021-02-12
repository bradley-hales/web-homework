defmodule HomeworkWeb.Resolvers.CompaniesResolver do
  alias Homework.Transactions
  alias Homework.Users
  alias Homework.Companies

  @doc """
  Get a list of companies
  """
  def companies(_root, args, _info) do
    {:ok, Companies.list_companies(args)}
  end

  @doc """
  Get the users associated with a company
  """
  def users(_root, _args, %{source: %{company_id: company_id}}) do
    {:ok, Users.get_users_by_company_id!(company_id)}
  end

  @doc """
  Get the transactions associated with a company
  """
  def transactions(_root, _args, %{source: %{company_id: company_id}}) do
    {:ok, Transactions.get_transactions_by_company_id!(company_id)}
  end

  @doc """
  Create a new company
  """
  def create_company(_root, args, _info) do
    case Companies.create_company(args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not create company: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a company for an id with args specified.
  """
  def update_company(_root, %{id: id} = args, _info) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a company for an id
  """
  def delete_company(_root, %{id: id}, _info) do
    company = Companies.get_company!(id)

    case Companies.delete_company(company) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end
end
