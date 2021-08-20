defmodule Postpaid do
  defstruct value: 0

  @minute_cost 1.40

  def make_call(number, date, duration) do
    Subscriber.search_subscriber(number, :postpaid)
    |> MakeCall.register(date, duration)

    {:ok, "Call made successfully! duration of #{duration} minutes"}
  end

  def print_account(month, year, number) do
    subscriber = Accounts.print_out(month, year, number, :postpaid)

    amount =
      subscriber
      |> Enum.map(&(&1.duration * @minute_cost))
      |> Enum.sum()

    %Subscriber{subscriber | plan: %__MODULE__{value: amount}}
  end
end
