defmodule DBounceTest do
  use ExUnit.Case, async: true

  require Logger
  # doctest DBounce

  test "start_link without name" do
    assert {:ok, _} = DBounce.start_link
  end

  test "start_link with name" do
    assert {:ok, _} = DBounce.start_link(:bouncer123)
  end

  require Logger
  test "bounce without name" do
    {:ok, _} = DBounce.start_link

    table = :ets.new(:table, [:set, :public])

    spawn fn ->
      DBounce.bounce(:task1, fn -> :ets.insert(table, {:value1, "hello"}) end, 500)
    end

    spawn fn ->
      DBounce.bounce(:task1, fn -> :ets.insert(table, {:value2, "world"}) end, 500)
    end

    :timer.sleep(750)

     assert :ets.lookup(table, :value1) == []
     assert :ets.lookup(table, :value2) == [{:value2, "world"}]
  end

  test "bounce with name" do
    {:ok, _} = DBounce.start_link(:bouncer1)

    table = :ets.new(:table, [:set, :public])

    spawn fn ->
      DBounce.bounce(:bouncer1, :task1, fn -> :ets.insert(table, {:value1, "hello"}) end, 500)
    end

    spawn fn ->
      DBounce.bounce(:bouncer1, :task1, fn -> :ets.insert(table, {:value2, "world"}) end, 500)
    end

    :timer.sleep(750)

     assert :ets.lookup(table, :value1) == []
     assert :ets.lookup(table, :value2) == [{:value2, "world"}]
  end


  test "bounce without start_link" do
  end
end
