defmodule Dec64 do
  @type t :: <<_::64>>

  defmacrop int_b(num, min, max) do
    quote do: unquote(num) >= unquote(min) and unquote(num) <= unquote(max)
  end

  def new(0, _), do: zero()
  def new(coefficient, exponent)
    when int_b(coefficient, -36028797018963968, 36028797018963967)
      and int_b(exponent, -127, 128),
    do: <<coefficient::56>> <> <<exponent::8>>


  def nan, do: <<0x80::64>>
  def zero, do: <<0::64>>
  def one, do: <<0x100::64>>
  def negative_one, do: <<0xFFFFFFFFFFFFFF00::64>>

  @spec sum(Dec64.t, Dec64.t) :: Dec64.t
  def sum(_, _), do: nan()
end

defmodule Dec64.Operators do
  @spec (Dec64.t + Dec64.t) :: Dec64.t
  def a + b, do: Dec64.sum(a, b)
end
