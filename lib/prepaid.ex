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
        subscriber = %Subscriber{subscriber | plan: plan}
        {:ok, "Your call cost #{cost}, and you have #{plan.credits} credits"}

      true ->
        {:error, "You don't have credits to make this call, make a recharge!"}
    end
  end
end
