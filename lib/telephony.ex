defmodule Telephony do

  def start do
    File.write!("postpaid.txt", :erlang.term_to_binary([]))
    File.write!("prepaid.txt", :erlang.term_to_binary([]))
  end

  def register_subscriber(name, number, cpf, plan) do
    Subscriber.register(name, number, cpf, plan)
  end
end
