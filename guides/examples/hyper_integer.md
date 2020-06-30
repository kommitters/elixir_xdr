# XDR.HyperInt - Hyper Integer
It is an extension of the Integer type defined above. Represents a 64-bit (8-byte) integer with values in a range of `[-9_223_372_036_854_775_808, 9_223_372_036_854_775_807]`.

[Hyper Integer - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.5)

## Usage

### Encoding

```elixir 
iex(1)> XDR.HyperInt.new(9_223_372_036_854_775_807) |> XDR.HyperInt.encode_xdr()
{:ok, <<127, 255, 255, 255, 255, 255, 255, 255>>}

iex(1)> XDR.HyperInt.new(258963) |> XDR.HyperInt.encode_xdr!()
<<0, 0, 0, 0, 0, 3, 243, 147>>
```

### Decoding

```elixir
iex(1)> XDR.HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{:ok, {%XDR.HyperInt{datum: 258963}, <<>>}}

iex(1)> XDR.HyperInt.decode_xdr!(<<127, 255, 255, 255, 255, 255, 255, 255>>)
{%XDR.HyperInt{datum: 9223372036854775807}, <<>>}
```

### Custom Hyper Integer

```elixir
  defmodule CustomHyperInt do

    @type t :: XDR.HyperInt.t()

    defdelegate new(num), to: XDR.HyperInt
    defdelegate encode_xdr(hyper_int), to: XDR.HyperInt
    defdelegate encode_xdr!(hyper_int), to: XDR.HyperInt
    defdelegate decode_xdr(bytes), to: XDR.HyperInt
    defdelegate decode_xdr!(bytes), to: XDR.HyperInt
  end
```

```elixir
# Encode
CustomHyperInt.new(123) |> CustomHyperInt.encode_xdr()

# Decode
CustomHyperInt.decode_xdr!(<<0, 0, 2, 52>>)
```
