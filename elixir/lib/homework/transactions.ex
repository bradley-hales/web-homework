defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Transactions.Transaction
  alias Homework.Companies.Company
  alias Homework.Companies

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions([])
      [%Transaction{}, ...]

  """
  # def list_transactions(_args) do
  # Transaction
  #    |> select([t], %{id: t.id, amount: (t.amount / 100), company_id: t.company_id, credit: t.credit, debit: t.debit, description: t. description, merchant_id: t.merchant_id, user_id: t.user_id})
  #    |> Repo.all()
  # end
  def list_transactions(_args) do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id) do
   Repo.get!(Transaction, id)
  end
  
  @doc """
  Gets multiple transactions by company id.

  Raises `Ecto.NoResultsError` if a Transaction with the given company id does not exist.

  ## Examples

      iex> get_transactions_by_company_id!(123)
      [%Transaction{}, ...]

      iex> get_transaction_by_company_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transactions_by_company_id!(company_id) do
   Transaction
    |> where(company_id: ^company_id)
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    # int_val = convert_decimal_to_int(attrs[:amount])
    # updated_attrs = %{attrs | amount: int_val}
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
    |> update_available_credit()
  end

  defp convert_decimal_to_int(decimal) do 
    decimal * 100
  end

  defp convert_int_to_decimal(int_val) do 
    int_val / 100
  end

  defp sum_debit_transactions_for_company!(company_id) do
    Transaction
     |> where([t], t.company_id == ^(company_id) and t.debit == true)
     |> select([t], sum(t.amount))
     |> Repo.one()
     # Repo.one(from t in Transaction,
     #  where: t.company_id == ^company_id and t.debit == true,
     #  select: sum(t.amount))
  end

  defp update_available_credit({:ok, transaction}) do
  # get company and create attrs = {available_credit: sum_debit_transactions}
  # maybe do it in the resolver
    company = Companies.get_company!(transaction.company_id)
    debit_transactions = sum_debit_transactions_for_company!(transaction.company_id)
    available = company.credit_line - debit_transactions
    Companies.update_company(company, %{credit_line: company.credit_line, available_credit: available})
    transaction
  end

  defp update_available_credit({:error, changeset}) do
    Repo.get_by!(Transaction, id: changeset.data.id)
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    updated_params = attrs
    if Map.has_key?(attrs, :amount) do
      updated_amount = convert_decimal_to_int(attrs[:amount])
      updated_params = %{attrs | amount: updated_amount}
    end
    transaction
    |> Transaction.changeset(updated_params)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
