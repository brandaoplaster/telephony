defmodule Prepaid do
  defstruct credits: 0, recharges: []

  @minute_price 1.45

  def make_call(number, date, duration) do
    cost = @minute_price * duration

    subscriber = Subscriber.search_subscriber(number, :prepaid)

    cond do
      cost <= subscriber.plan ->
        plan = subscriber.plan
        plan = %__MODULE__{plan | credits: plan.credits - cost}

        %Subscriber{subscriber | plan: plan}
        |> MakeCall.register(date, duration)

        {:ok, "Your call cost #{cost}, and you have #{plan.credits} credits"}

      true ->
        {:error, "You don't have credits to make this call, make a recharge!"}
    end
  end

  def print_account(month, year, number) do
    Accounts.print_out(month, year, number, :prepaid)
  end
end
