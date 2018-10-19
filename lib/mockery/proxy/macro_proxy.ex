defmodule Mockery.Proxy.MacroProxy do
  @moduledoc false

  alias Mockery.Proxy

  def unquote(:"$handle_undefined_function")(name, args) do
    {mod, by} =
      case Process.get(Mockery.MockableModule, []) do
        [] ->
          raise Mockery.Error, """
          Mockery.Macro.mockable/2 needs to be invoked directly in other function.

          You can't use it in module attribute:
              import Mockery.Macro
              @foo mockable(Foo)

              def bar, do: @foo.foo()

          Instead use:
              import Mockery.Macro

              def bar, do: mockable(Foo).foo()
          """

        [valid | rest] ->
          _ = Process.put(Mockery.MockableModule, rest)
          valid
      end

    Proxy.do_proxy(mod, name, args, by)
  end
end
