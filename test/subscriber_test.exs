defmodule SubscriberTest do
  use ExUnit.Case
  doctest Subscriber

  setup do
    File.write("prepaid_test.txt", :erlang.term_to_binary([]))
    File.write("postpaid_test.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepaid_test.txt")
      File.rm("postpaid_test.txt")
    end)
  end

  describe "tests to register subscriber" do
    test "when to register a prepaid account" do
      subscriber = Subscriber.register("Lucas", "12345", "123456")

      assert subscriber == {:ok, "Lucas subscriber successfully registered"}
    end
  end
end
