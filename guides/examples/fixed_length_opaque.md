# XDR.FixedOpaque - Fixed-Length Opaque Data
Represents a fixed-length uninterpreted data (This data is called "opaque") that needs to be passed among machines.  

[Fixed-Length Opaque Data - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.9)

## Usage

In the following examples we will use an opaque of 12-bytes length:

### Encoding

```elixir 
iex(1)> XDR.FixedOpaque.new(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, 12) |> XDR.FixedOpaque.encode_xdr()
{:ok, <<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>}

iex(1)> XDR.FixedOpaque.new(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, 12) |> XDR.FixedOpaque.encode_xdr!()
<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>
```

### Decoding

```elixir
iex(1)> XDR.FixedOpaque.decode_xdr(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, %{length: 12})
{:ok, {%XDR.FixedOpaque{length: 12, opaque: <<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>}, ""}} 

iex(1)> opaque_spec = XDR.FixedOpaque.new(nil, 12)
iex(2)> XDR.FixedOpaque.decode_xdr!(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, opaque_spec)
{%XDR.FixedOpaque{length: 12, opaque: <<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>}, ""}
```

### Custom Fixed-Length Opaque Data example

```elixir
  defmodule CustomFixedOpaque do

    @length 10

    @type t :: XDR.FixedOpaque.t()

    @spec new(opaque :: binary()) :: XDR.FixedOpaque.t()
    def new(opaque \\ nil), do: XDR.FixedOpaque.new(opaque, @length)

    defdelegate encode_xdr(fixed_opaque), to: XDR.FixedOpaque
    defdelegate encode_xdr!(fixed_opaque), to: XDR.FixedOpaque
    defdelegate decode_xdr(bytes, fixed_opaque \\ new()), to: XDR.FixedOpaque
    defdelegate decode_xdr!(bytes, fixed_opaque \\ new()), to: XDR.FixedOpaque
  end
```

```elixir
# Encode
CustomFixedOpaque.new(<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>) |> CustomFixedOpaque.encode_xdr()

# Decode
CustomFixedOpaque.decode_xdr!(<<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>)
```
