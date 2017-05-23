# Dec64

Implementation, for fun, of the number type [dec64][http://dec64.com] by Douglas
Crockford

## Installation

```elixir
def deps do
  [{:dec64, github: "graffic/elixir-dec64"}]
end
```

## Implementation notes

In the original implementation for the new operator, the tests show some kind
of rounding I could not replicate running that part of assembler. So right 
now there is just a `div` and no rounding.
