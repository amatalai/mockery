defmodule MockeryTest do
  use ExUnit.Case, async: true

  test "of/2 dev env" do
    assert Mockery.of(A, env: :dev) == A
    assert Mockery.of(A, by: Z, env: :dev) == A
  end

  test "of/2 test env" do
    assert Mockery.of(A) == {Mockery.Proxy, A}
    assert Mockery.of(A, by: Z) == {Z, :ok}
  end

  test "mock/3 with name" do
    Mockery.mock(Dummy, :fun1, "value1")

    assert Process.get({Mockery, {Dummy, :fun1}}) == "value1"
  end

  test "mock/3 with name and arity" do
    Mockery.mock(Dummy, [fun1: 0], "value2")

    assert Process.get({Mockery, {Dummy, {:fun1, 0}}}) == "value2"
  end
end