defmodule Dec64Test do
  use ExUnit.Case
  use ExUnit.Parameterized
  doctest Dec64

  test "new has the right size" do
    assert bit_size(Dec64.new(1 ,1)) == 64
  end

  test_with_params "new dec64",
    fn (c, e, expected) ->
      assert expected == Dec64.new(c, e)
    end do
      [
        {0, 0, <<0::64>>},
        {0, 0, Dec64.zero},
        {1, 0, <<0x100::64>>},
        {1, 0, Dec64.one},
        {0, 1000, Dec64.zero},
        {0, -1000, Dec64.zero}
      ]
    end
end
