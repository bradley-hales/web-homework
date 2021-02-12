# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Homework.Repo 
alias Homework.Transactions.Transaction
alias Homework.Users.User
alias Homework.Merchants.Merchant
alias Homework.Companies.Company
alias Homework.Companies
alias Homework.Users
alias Homework.Merchants
alias Homework.Transactions



companies_data = [
    %{
        available_credit: 0,
        credit_line: 500,
        name: "Divvy"
    },
    %{
        available_credit: 0,
        credit_line: 600,
        name: "Brad's Company"
    },
    %{
        available_credit: 0,
        credit_line: 200,
        name: "Cool Company"
    }
]

# create some companies
Enum.each(companies_data, fn(data) ->
  Companies.create_company(data)
end)

companies = Companies.list_companies([])
id_of_company = Enum.at(companies, 0).id
second_company_id = Enum.at(companies, 1).id
users_data = [
    %{
        company_id: id_of_company,
        dob: "2020-03-05",
        first_name: "Tom",
        last_name: "Jenkin"
    },
    %{
        company_id: second_company_id,
        dob: "2020-03-05",
        first_name: "Jasper",
        last_name: "James"
    }
]

Enum.each(users_data, fn(data) ->
  Users.create_user(data)
end)

merchant_data = [
    %{
        description: "Here is a test description",
        name: "Cool Merchant"
    },
    %{
        description: "An ok merchant",
        name: "OK Merchant"
    }
]

Enum.each(merchant_data, fn(data) ->
  Merchants.create_merchant(data)
end)

merchants = Merchants.list_merchants([])
merchant_id_one = Enum.at(merchants, 0).id
merchant_id_two = Enum.at(merchants, 1).id
users = Users.list_users([])
user_one = Enum.at(users, 0).id 
user_two = Enum.at(users, 1).id
transactions_data = [
    %{
        amount: 10,
        company_id: id_of_company,
        credit: false,
        debit: true,
        description: "A transaction for $10.0",
        merchant_id: merchant_id_one,
        user_id: user_one
    },
    %{
        amount: 20,
        company_id: id_of_company,
        credit: false,
        debit: true,
        description: "A transaction for $20.0",
        merchant_id: merchant_id_one,
        user_id: user_one
    },
    %{
        amount: 10,
        company_id: second_company_id,
        credit: false,
        debit: true,
        description: "A transaction for $10.0",
        merchant_id: merchant_id_two,
        user_id: user_two
    },
    %{
        amount: 15,
        company_id: second_company_id,
        credit: false,
        debit: true,
        description: "A transaction for $15.0",
        merchant_id: merchant_id_two,
        user_id: user_two
    }
]

Enum.each(transactions_data, fn(data) ->
  Transactions.create_transaction(data)
end)

# Homework.Repo.insert!(%User{first_name: "Brad", last_name: "hales", dob: "2019-05-06"})
# Homework.Repo.insert!(%User{first_name: "Tom", last_name: "Durant", dob: "2015-07-08"})
# Homework.Repo.insert!(%Merchant{name: "Divvy", description: "The Best!"})
# Homework.Repo.insert!(%Transaction{amount: 25, credit: true, debit: false, description: "25 dollar deposit", user_id: "765a5b32-e2f0-4aea-88dc-442d151ea138", merchant_id: "3cf999ba-9a11-4c76-bc33-ee47d4f157f4"})
