# Unsigned Hyper Integer

Represents integer values in the range `[0, 18446744073709551615]`

## Usage

### Encoding

```elixir 
iex> XDR.HyperUInt.new(258963) |> XDR.HyperUInt.encode_xdr()
{:ok, <<0, 0, 0, 0, 0, 3, 243, 147>>}

iex> XDR.HyperUInt.new(258963) |> XDR.HyperUInt.encode_xdr!()
<<0, 0, 0, 0, 0, 3, 243, 147>>
```

### Decoding

```elixir
iex> XDR.HyperUInt.decode_xdr(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{:ok, {%XDR.HyperUInt{datum: 258963}, <<>>}}

iex> XDR.HyperUInt.decode_xdr!(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{%XDR.HyperUInt{datum: 258963}, <<>>}
```