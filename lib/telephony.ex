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
end
