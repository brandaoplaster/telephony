defmodule MakeCall do

  defstruct date: nil, duration: nil

  def register(subscriber, date, plan) do
    subscriber_updated = %Subscriber{
      subscriber | calls: subscriber.calls ++ [%__MODULE__{date: date, duration: duration}]
    }

    subscriber = Subscriber.update(subscriber.number, subscriber_updated)
  end
end
