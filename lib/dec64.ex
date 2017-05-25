defmodule Dec64 do
  @type t :: <<_::64>>

  @min_c -36028797018963968
  @max_c 36028797018963967
  @max_100_c 3602879701896396800

  defmacrop int_b(num, min, max) do
    quote do: unquote(num) >= unquote(min) and unquote(num) <= unquote(max)
  end

  @doc """
  Creates a new 64bit dec64 number.

  1. If the coefficient is zero, the number is zero.
  2. If the exponent is too big (in the positive side). Multiply by ten and
     reduce the exponent one by one.
  3. If the coefficient bigger than max_coeff * 100, do integer divisions to
     make it smaller while increasing the exponent.
  4. If the coefficient is still big or the exponent is too small: increase
     it.

  """
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
    when abs(coefficient) > @max_100_c
  do
    new(div(coefficient, 10), exponent + 1)
  end

  def new(coefficient, exponent)
    when abs(coefficient) > @max_c or exponent < -127
  do
    extra = if abs(coefficient) > 360287970189639679, do: 2, else: 1
    difference = max(extra, -127 - exponent)
    if difference >= 20 do
      zero()
    else
      sign = if coefficient >= 0, do: 1, else: -1
      almost_power = :math.pow(10, difference - 1) |> round
      new(
        div(coefficient + (sign * almost_power * 5), almost_power * 10),
        exponent + difference)
    end
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
