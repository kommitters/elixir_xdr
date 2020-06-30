# XDR.Int - Integer
An XDR signed integer is a 32-bit datum that encodes an integer in the range `[-2_147_483_648, 2_147_483_647]`.

[Integer - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.1)

## Usage

### Encoding

```elixir
iex(1)> XDR.Int.new(564) |> XDR.Int.encode_xdr()
{:ok, <<0, 0, 2, 52>>}

iex(1)> XDR.Int.new(564) |> XDR.Int.encode_xdr!()
<<0, 0, 2, 52>>

```

### Decoding

```elixir
iex(1)> XDR.Int.decode_xdr(<<0, 0, 2, 52>>)
{:ok, {%XDR.Int{datum: 564}, <<>>}}

iex(1)> XDR.Int.decode_xdr!(<<0, 0, 2, 52>>)
{%XDR.Int{datum: 564}, <<>>}
```

### Custom Integer example

```elixir
  defmodule CustomInt do

    @type t :: XDR.Int.t()

    defdelegate new(num), to: XDR.Int
    defdelegate encode_xdr(int), to: XDR.Int
    defdelegate encode_xdr!(int), to: XDR.Int
    defdelegate decode_xdr(bytes), to: XDR.Int
    defdelegate decode_xdr!(bytes), to: XDR.Int
  end
```

```elixir
# Encode
CustomInt.new(123) |> CustomInt.encode_xdr()

# Decode
CustomInt.decode_xdr!(<<0, 0, 2, 52>>)
```
