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

  def search_subscriber(number, key \\ :all) do
    search(number, key)
  end

  def prepaid_subscribers, do: read(:prepaid)

  def postpaid_subscribers, do: read(:postpaid)

  def all_subscribers, do: read(:prepaid) ++ read(:postpaid)

  defp search(number, :prepaid), do: subscribers_filter(prepaid_subscribers(), number)

  defp search(number, :postpaid), do: subscribers_filter(postpaid_subscribers(), number)

  defp search(number, :all), do: subscribers_filter(all_subscribers(), number)

  defp subscribers_filter(list, number), do: Enum.find(list, &(&1.number == number))

  defp write(subscriber_list, plan) do
    File.write(@subscriber[plan], subscriber_list)
  end

  defp read(plan) do
    {:ok, subscriber} = File.read(@subscriber[plan])

    subscriber
    |> :erlang.binary_to_term()
  end
end
