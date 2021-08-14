defmodule Telephony do

  def register_subscriber(name, number, cpf, plan) do
    Subscriber.register(name, number, cpf, plan)
  end
end
