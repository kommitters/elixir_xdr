# XDR.UInt - Unsigned Integer
Represents integer values in the range `[0, 4_294_967_295]`.

[Unsigned Integer - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.2)

## Usage

### Encoding

```elixir
iex(1)> XDR.UInt.new(564) |> XDR.UInt.encode_xdr()
{:ok, <<0, 0, 2, 52>>}

iex(1)> XDR.UInt.new(564) |> XDR.UInt.encode_xdr!()
<<0, 0, 2, 52>>

```

### Decoding

```elixir
iex(1)> XDR.UInt.decode_xdr(<<0, 0, 2, 52>>)
{:ok, {%XDR.UInt{datum: 564}, <<>>}}

iex(1)> XDR.UInt.decode_xdr!(<<0, 0, 2, 52>>)
{%XDR.UInt{datum: 564}, <<>>}
```

### Custom Unsigned Integer example

```elixir
  defmodule CustomUInt do

    @type t :: XDR.UInt.t()

    defdelegate new(num), to: XDR.UInt
    defdelegate encode_xdr(uint), to: XDR.UInt
    defdelegate encode_xdr!(uint), to: XDR.UInt
    defdelegate decode_xdr(bytes), to: XDR.UInt
    defdelegate decode_xdr!(bytes), to: XDR.UInt
  end
```

```elixir
# Encode
CustomUInt.new(123) |> CustomUInt.encode_xdr()

# Decode
CustomUInt.decode_xdr!(<<0, 0, 2, 52>>)
```
