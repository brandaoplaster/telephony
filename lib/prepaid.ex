defmodule Prepaid do

  defstruct credits: 0, recharges: []

  @minute_price 1.45

  def make_call(number, date, duration) do
    cost = @minute_price * duration

    subscriber = Subscriber.search_subscriber(number, :prepaid)

    cond do
      cost <= 10 -> {:ok, "Your call cost #{cost}"}
      true -> {:error, "You don't have credits to make this call, make a recharge!"}
    end

  end
end
