# Void

 Represents the XDR void type or nil in elixir case. Voids are useful for describing operations that take no data as input or no data as output.

## Usage

### Encoding

```elixir 
iex> XDR.Void.new(nil) |> XDR.Void.encode_xdr()
{:ok, <<>>}

iex> XDR.Void.new() |> XDR.Void.encode_xdr!()
<<>>
```

### Decoding

```elixir 
iex> XDR.Void.decode_xdr(<<>>)
{:ok, {nil, <<>>}}

iex> XDR.Void.decode_xdr!(<<>>)
{nil, <<>>}

iex> XDR.Void.decode_xdr(<<72, 101, 108, 108, 111, 0>>)
{:ok, {nil, <<72, 101, 108, 108, 111, 0>>}}

iex> XDR.Void.decode_xdr!(<<72, 101, 108, 108, 111>>)
{nil, <<72, 101, 108, 108, 111, 0>>}
```
