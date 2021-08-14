defmodule Subscriber do
  defstruct name: nil, number: nil, cpf: nil

  @subscriber "subscriber.txt"

  def register(name, number, cpf) do
    read() ++ [%__MODULE__{name: name, number: number, cpf: cpf}]
    |> :erlang.term_to_binary()
    |> write()
  end

  defp write(subscriber_list) do
    File.write(@subscriber, subscriber_list)
  end

  defp read() do
    {:ok, subscriber} = File.read(@subscriber)

    subscriber
    |> :erlang.binary_to_term()
  end
end
