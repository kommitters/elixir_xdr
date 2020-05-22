# Fixed-Length Opaque

Represents fixed-length uninterpreted data that needs to be passed among machines.

## Usage

### Encoding

```elixir 
iex> XDR.FixedOpaque.new(<<1, 2, 3, 4, 5>>, 5) |> XDR.FixedOpaque.encode_xdr()
{:ok, <<1, 2, 3, 4, 5, 0, 0, 0>>}

iex> XDR.FixedOpaque.new(<<1, 2, 3>>, 3) |> XDR.FixedOpaque.encode_xdr!()
<<1, 2, 3, 0>>
```

### Decoding

```elixir
iex> XDR.FixedOpaque.decode_xdr(<<1, 2, 3, 4, 5, 0, 0, 0>>, %{length: 5})
{:ok, {%XDR.FixedOpaque{length: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}}

iex> XDR.FixedOpaque.decode_xdr!(<<1, 2, 3, 4, 5, 0, 0, 0>>, %{length: 5})
{%XDR.FixedOpaque{length: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}
```