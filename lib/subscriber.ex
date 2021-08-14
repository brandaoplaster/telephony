defmodule Subscriber do
  defstruct name: nil, number: nil, cpf: nil, plan: nil

  @subscriber %{:prepaid => "prepaid.txt", :postpaid => "postpaid.txt"}

  def register(name, number, cpf, plan \\ :prepaid) do
    case search_subscriber(number) do
      nil ->
        (read(plan) ++ [%__MODULE__{name: name, number: number, cpf: cpf, plan: plan}])
        |> :erlang.term_to_binary()
        |> write(plan)

        {:ok, "#{name} subscriber successfully registered"}

      _subscriber ->
        {:error, "Subscriber number already exists"}
    end
  end

  def search_subscriber(number) do
    (read(:prepaid) ++ read(:postpaid))
    |> Enum.find(fn subscriber -> subscriber.number == number end)
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
