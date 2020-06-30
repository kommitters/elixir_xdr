# XDR.DoubleFloat - Double-Precision Floating-Point
Represents a Double-precision float value (64 bits, 8 bytes).

[Double-Precision Floating-Point - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.7)

## Usage

### Encoding

```elixir 
iex(1)> XDR.DoubleFloat.new(0.333333333333333314829616256247390992939472198486328125) |> XDR.DoubleFloat.encode_xdr()
{:ok, <<63, 213, 85, 85, 85, 85, 85, 85>>}

iex(1)> XDR.DoubleFloat.new(258963) |> XDR.DoubleFloat.encode_xdr!()
<<65, 15, 156, 152, 0, 0, 0, 0>> 
```

### Decoding

```elixir
iex(1)> XDR.DoubleFloat.decode_xdr(<<65, 15, 156, 152, 0, 0, 0, 0>>)
{:ok, {%XDR.DoubleFloat{float: 258963.0}, ""}}

iex(1)> XDR.DoubleFloat.decode_xdr!(<<64, 11, 174, 20, 122, 225, 71, 174>>)
{%XDR.DoubleFloat{float: 3.46}, <<>>}
```

### Custom Double-Precision Floating-Point example

```elixir
  defmodule CustomDoubleFloat do

    @type t :: XDR.DoubleFloat.t()

    defdelegate new(num), to: XDR.DoubleFloat
    defdelegate encode_xdr(double_float), to: XDR.DoubleFloat
    defdelegate encode_xdr!(double_float), to: XDR.DoubleFloat
    defdelegate decode_xdr(bytes), to: XDR.DoubleFloat
    defdelegate decode_xdr!(bytes), to: XDR.DoubleFloat
  end
```

```elixir
# Encode
CustomDoubleFloat.new(123.999) |> CustomDoubleFloat.encode_xdr()

# Decode
CustomDoubleFloat.decode_xdr!(<<64, 94, 255, 239, 157, 178, 45, 14>>)
```
