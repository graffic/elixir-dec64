defmodule Dec64 do
  @type t :: <<_::64>>

  @min_c -36028797018963968
  @max_c 36028797018963967

  defmacrop int_b(num, min, max) do
    quote do: unquote(num) >= unquote(min) and unquote(num) <= unquote(max)
  end

  def new(0, _), do: zero()
  def new(coefficient, exponent)
    when int_b(coefficient, @min_c, @max_c)
      and int_b(exponent, -127, 127),
    do: <<coefficient::56>> <> <<exponent::8>>

  def new(coefficient, exponent)
    when exponent >= 127 and coefficient < @min_c,
    do: nan()

  def new(coefficient, exponent)
    when exponent > 127,
    do: new(coefficient * 10, exponent - 1)

  def new(coefficient, exponent)
    when not int_b(coefficient, @min_c, @max_c) or exponent < -127
  do
    # No rounding here, but tests in the original asm implementation suggest
    # there is some rounding here
    new(div(coefficient, 10), exponent + 1)
  end

  def nan, do: <<0x80::64>>
  def zero, do: <<0::64>>
  def one, do: <<0x100::64>>
  def negative_one, do: <<0xFFFFFFFFFFFFFF00::64>>

  @spec sum(t, t) :: t
  def sum(_, _), do: nan()

end

defmodule Dec64.Operators do
  @spec (Dec64.t + Dec64.t) :: Dec64.t
  def a + b, do: Dec64.sum(a, b)
end
