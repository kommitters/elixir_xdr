# XDR.HyperUInt - Unsigned Hyper Integer
It is an extension of the Unsigned Integer type defined above. Represents a 64-bit (8-byte) unsigned integer with values in a range of `[0, 18_446_744_073_709_551_615]`.

[Unsigned Hyper Integer - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.5)

## Usage

### Encoding

```elixir 
iex(1)> XDR.HyperUInt.new(258963) |> XDR.HyperUInt.encode_xdr()
{:ok, <<0, 0, 0, 0, 0, 3, 243, 147>>}

iex(1)> XDR.HyperUInt.new(18_446_744_073_709_551_615) |> XDR.HyperUInt.encode_xdr!()
<<255, 255, 255, 255, 255, 255, 255, 255>>
```

### Decoding

```elixir
iex(1)> XDR.HyperUInt.decode_xdr(<<255, 255, 255, 255, 255, 255, 255, 255>>)
{:ok, {%XDR.HyperUInt{datum: 18446744073709551615}, <<>>}}

iex(1)> XDR.HyperUInt.decode_xdr!(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{%XDR.HyperUInt{datum: 258963}, <<>>}
```

### Custom Unsigned Integer example

```elixir
  defmodule CustomHyperUInt do

    @type t :: XDR.HyperHyperUInt.t()

    defdelegate new(num), to: XDR.HyperHyperUInt
    defdelegate encode_xdr(hyper_uint), to: XDR.HyperHyperUInt
    defdelegate encode_xdr!(hyper_uint), to: XDR.HyperHyperUInt
    defdelegate decode_xdr(bytes), to: XDR.HyperHyperUInt
    defdelegate decode_xdr!(bytes), to: XDR.HyperHyperUInt
  end
```

```elixir
# Encode
CustomHyperUInt.new(123) |> CustomHyperUInt.encode_xdr()

# Decode
CustomHyperUInt.decode_xdr!(<<0, 0, 2, 52>>)
```
