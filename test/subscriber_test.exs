defmodule SubscriberTest do
  use ExUnit.Case
  doctest Subscriber

  setup do
    File.write("prepaid.txt", :erlang.term_to_binary([]))
    File.write("postpaid.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepaid.txt")
      File.rm("postpaid.txt")
    end)
  end

  describe "testing subscriber registration" do
    test "when to register a prepaid account" do
      subscriber = Subscriber.register("Lucas", "12345", "123456", :prepaid)
      expected_response = {:ok, "Lucas subscriber successfully registered"}
      assert subscriber == expected_response
    end

    test "when to register a postpaid account" do
      subscriber = Subscriber.register("Brandao", "09876", "09876", :postpaid)
      expected_response = {:ok, "Brandao subscriber successfully registered"}
      assert subscriber == expected_response
    end

    test "When the subscriber structure returns" do
      subscriber =
        %Subscriber{name: "Brandao", number: "0987654", cpf: "0123456", plan: "prepaid"}.name ==
          "Brandao"
    end
  end
end
