defmodule Telephony do
  def start do
    File.write!("postpaid.txt", :erlang.term_to_binary([]))
    File.write!("prepaid.txt", :erlang.term_to_binary([]))
  end

  def register_subscriber(name, number, cpf, plan) do
    Subscriber.register(name, number, cpf, plan)
  end

  def subscriber_list, do: Subscriber.all_subscribers()

  def prepaid_subscriber_list, do: Subscriber.prepaid_subscribers()

  def postpaid_subscriber_list, do: Subscriber.postpaid_subscribers()

  def make_call(number, plan, date, duration) do
    cond do
      plan == :prepaid -> Prepaid.make_call(number, date, duration)
      plan == :postpaid -> Postpaid.make_call(number, date, duration)
    end
  end

  def recharge(date, value, number), do: Recharge.call(date, value, number)

  def search_subscriber_by_number(number, plan \\ :all),
    do: Subscriber.search_subscriber(number, plan)

  def print_accounts(month, year) do
    Subscriber.prepaid_subscribers()
    |> Enum.each(fn subscriber ->
      subscriber = Prepaid.print_account(month, year, subscriber.number)
      IO.puts("#{subscriber.name} subscriber prepaid bills")
      IO.puts("Number: #{subscriber.number}")
      IO.puts("Calls:")
      IO.inspect(subscriber.calls)
      IO.puts("Recharges:")
      IO.inspect(subscriber.recharges)
      IO.puts("Total calls: #{Enum.count(subscriber.calls)}")
      IO.puts("Total recharges: #{Enum.count(subscriber.plan.recharges)}")
      IO.puts("==========================================================")
    end)

    Subscriber.postpaid_subscribers()
    |> Enum.each(fn subscriber ->
      subscriber = Postpaid.print_account(month, year, subscriber.number)
      IO.puts("#{subscriber.name} subscriber postpaid bills")
      IO.puts("Number: #{subscriber.number}")
      IO.puts("Calls:")
      IO.inspect(subscriber.calls)
      IO.puts("Total calls: #{Enum.count(subscriber.calls)}")
      IO.puts("Invoice amount: #{subscriber.plan.value}")
      IO.puts("==========================================================")
    end)
  end
end
