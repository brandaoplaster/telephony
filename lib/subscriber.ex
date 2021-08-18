defmodule Subscriber do
  defstruct name: nil, number: nil, cpf: nil, plan: nil, calls: []

  @subscriber %{:prepaid => "prepaid.txt", :postpaid => "postpaid.txt"}

  def register(name, number, cpf, :prepaid), do: register(name, number, cpf, %Prepaid{})
  def register(name, number, cpf, :postpaid), do: register(name, number, cpf, %Postpaid{})

  def register(name, number, cpf, plan) do
    case search_subscriber(number) do
      nil ->
        subscriber = %__MODULE__{name: name, number: number, cpf: cpf, plan: plan}

        (read(get_plan(subscriber)) ++ [subscriber])
        |> :erlang.term_to_binary()
        |> write(get_plan(subscriber))

        {:ok, "#{name} subscriber successfully registered"}

      _subscriber ->
        {:error, "Subscriber number already exists"}
    end
  end

  def search_subscriber(number, key \\ :all) do
    search(number, key)
  end

  def delete(number) do
    {subscriber, new_subscriber_list} = deletar_item(number)

    new_subscriber_list
    |> :erlang.term_to_binary()
    |> write(subscriber.plan)

    {:ok, "#{subscriber.name} subscriber successfully deleted!"}
  end

  def update(number, subscriber) do
    {old_subscriber, new_subscriber_list} = deletar_item(number)

    case subscriber.plan.__struct__ == old_subscriber.plan.__struct__ do
      true ->
        (new_subscriber_list ++ [subscriber])
        |> :erlang.term_to_binary()
        |> write(get_plan(subscriber))

      false ->
        {:error, "subscriber cannot change the plan!"}
    end
  end

  def prepaid_subscribers, do: read(:prepaid)

  def postpaid_subscribers, do: read(:postpaid)

  def all_subscribers, do: read(:prepaid) ++ read(:postpaid)

  defp deletar_item(number) do
    subscriber = search_subscriber(number)

    new_subscriber_list =
      read(get_plan(subscriber))
      |> List.delete(subscriber)

    {subscriber, new_subscriber_list}
  end

  defp get_plan(subscriber) do
    case subscriber.plan.__struct__ == Prepaid do
      true -> :prepaid
      false -> :postpaid
    end
  end

  defp search(number, :prepaid), do: subscribers_filter(prepaid_subscribers(), number)

  defp search(number, :postpaid), do: subscribers_filter(postpaid_subscribers(), number)

  defp search(number, :all), do: subscribers_filter(all_subscribers(), number)

  defp subscribers_filter(list, number), do: Enum.find(list, &(&1.number == number))

  defp write(subscriber_list, plan) do
    File.write(@subscriber[plan], subscriber_list)
  end

  defp read(plan) do
    case File.read(@subscriber[plan]) do
      {:ok, subscriber} ->
        subscriber
        |> :erlang.binary_to_term()

      {:error, :ennoent} ->
        {:error, "Invalid file"}
    end
  end
end
