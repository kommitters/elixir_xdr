# XDR.Float - Floating-Point
Represents a single-precision float value (32 bits, 4 bytes).

[Floating-Point - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.6)

## Usage

### Encoding

```elixir 
iex(1)> XDR.Float.new(3.46) |> XDR.Float.encode_xdr()
{:ok, <<64, 93, 112, 164>>}

iex(1)> XDR.Float.new(-2589) |> XDR.Float.encode_xdr!()
<<197, 33, 208, 0>> 
```

### Decoding

```elixir
iex(1)> XDR.Float.decode_xdr(<<64, 93, 112, 164>>)
{:ok, {%XDR.Float{float: 3.4600000381469727}, <<>>}}

iex(1)> XDR.Float.decode_xdr!(<<197, 33, 208, 0>>)
{%XDR.Float{float: -2589.0}, <<>>}
```

### Custom Floating-Point example

```elixir
  defmodule CustomFloat do

    @type t :: XDR.Float.t()

    defdelegate new(num), to: XDR.Float
    defdelegate encode_xdr(float), to: XDR.Float
    defdelegate encode_xdr!(float), to: XDR.Float
    defdelegate decode_xdr(bytes), to: XDR.Float
    defdelegate decode_xdr!(bytes), to: XDR.Float
  end
```

```elixir
# Encode
CustomFloat.new(<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>) |> CustomFloat.encode_xdr()

# Decode
CustomFloat.decode_xdr!(<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>)
```
