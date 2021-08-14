defmodule Subscriber do
  defstruct name: nil, number: nil, cpf: nil, plan: nil

  @subscriber %{:prepaid => "prepaid.txt", :postpaid => "postpaid.txt"}

  def register(name, number, cpf, plan) do
    read(plan) ++ [%__MODULE__{name: name, number: number, cpf: cpf, plan: plan}]
    |> :erlang.term_to_binary()
    |> write(plan)
  end

  defp write(subscriber_list, plan) do
    File.write(@subscriber[plan], subscriber_list)
  end

  defp read(plan) do
    {:ok, subscriber} = File.read(@subscriber[plan])

    subscriber
    |> :erlang.binary_to_term()
  end
end
