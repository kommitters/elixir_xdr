# Floating Point

Represents Double-precision float values (64 bits, 8 bytes)
## Usage

### Encoding

```elixir 
iex> XDR.DoubleFloat.new(3.46) |> XDR.DoubleFloat.encode_xdr()
{:ok, <<64, 11, 174, 20, 122, 225, 71, 174>>}

iex> XDR.DoubleFloat.new(258963) |> XDR.DoubleFloat.encode_xdr!()
<<64, 11, 174, 20, 122, 225, 71, 174>>
```

### Decoding

```elixir
iex> XDR.DoubleFloat.decode_xdr(<<64, 11, 174, 20, 122, 225, 71, 174>>)
{:ok, {%XDR.DoubleFloat{float: 3.46}, <<>>}}

iex> XDR.DoubleFloat.decode_xdr!(<<64, 11, 174, 20, 122, 225, 71, 174>>)
{:ok, {%XDR.DoubleFloat{float: 3.46}, <<>>}}
```