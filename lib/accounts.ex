defmodule Accounts do
  def print_out(month, year, number, plan) do
    subscriber = Subscriber.search_subscriber(number)

    calls_month = get_calls_month(subscriber.calls, month, year)

    cond do
      plan == :prepaid ->
        recharges_month = get_calls_month(subscriber.plan.recharges, month, year)
        plan = %Prepaid{subscriber.plan | recharges: recharges_month}
        %Subscriber{subscriber | calls: calls_month, plan: plan}

      plan == :postpaid ->
        %Subscriber{subscriber | calls: calls_month}
    end
  end

  def get_calls_month(elements, month, year) do
    elements
    |> Enum.find(&(&1.date.year == year && &1.date.month == month))
  end
end
