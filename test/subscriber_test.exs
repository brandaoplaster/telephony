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

  describe "test to search subscriber" do
    test "When to look for a prepaid subscriber" do
      Subscriber.register("Brandao", "0123", "09876", :prepaid)
      assert Subscriber.search_subscriber("0123", :prepaid).name == "Brandao"
      assert Subscriber.search_subscriber("0123", :prepaid).plan.__struct__ == Prepaid
    end

    test "When to look for a postpaid subscriber" do
      Subscriber.register("Brandao", "0123", "09876", :postpaid)
      assert Subscriber.search_subscriber("0123", :postpaid).name == "Brandao"
      assert Subscriber.search_subscriber("0123", :postpaid).plan.__struct__ == Postpaid
    end
  end

  describe "testing subscriber deletion" do
    test "when to delete a prepaid subscriber" do
      Subscriber.register("Brandao", "0012", "09876", :prepaid)
      Subscriber.register("teste one delete", "0234", "08765", :prepaid)

      expected_response = {:ok, "Brandao subscriber successfully deleted!"}
      assert Subscriber.delete("0012") == expected_response
    end

    test "when to delete a postpaid subscriber" do
      Subscriber.register("Brandao", "0012", "09876", :postpaid)
      Subscriber.register("teste tow delete", "0234", "08765", :postpaid)

      expected_response = {:ok, "Brandao subscriber successfully deleted!"}
      assert Subscriber.delete("0012") == expected_response
    end
  end
end
