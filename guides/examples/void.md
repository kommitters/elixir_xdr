# XDR.Void - Void
Represents a 0-byte quantity. Voids are useful for describing operations that take no data as input or no data as output.

[Void - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.16)

## Usage

### Encoding

```elixir 
iex(1)> XDR.Void.new(nil) |> XDR.Void.encode_xdr()
{:ok, <<>>}

iex(1)> XDR.Void.new() |> XDR.Void.encode_xdr!()
<<>>
```

### Decoding

```elixir 
iex(1)> XDR.Void.decode_xdr(<<>>)
{:ok, {nil, <<>>}}

iex(1)> XDR.Void.decode_xdr!(<<72, 101, 108, 108, 111>>)
{nil, <<72, 101, 108, 108, 111, 0>>}
```

### Custom Void example

```elixir
  defmodule CustomVoid do

    @type t :: XDR.Void.t()

    defdelegate new(), to: XDR.Void
    defdelegate encode_xdr(void), to: XDR.Void
    defdelegate encode_xdr!(void), to: XDR.Void
    defdelegate decode_xdr(bytes), to: XDR.Void
    defdelegate decode_xdr!(bytes), to: XDR.Void
  end
```

```elixir
# Encode
CustomVoid.new() |> CustomVoid.encode_xdr()

# Decode
CustomVoid.decode_xdr!(<<>>)
```
