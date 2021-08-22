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
end
