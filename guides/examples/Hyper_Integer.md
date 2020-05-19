# Hyper Integer

Represents integer values in the range `[-9223372036854775808, 9223372036854775807]`

## Usage

### Encoding

```elixir 
iex> XDR.HyperInt.new(258963) |> XDR.HyperInt.encode_xdr()
{:ok, <<0, 0, 0, 0, 0, 3, 243, 147>>}

iex> XDR.HyperInt.new(258963) |> XDR.HyperInt.encode_xdr!()
<<0, 0, 0, 0, 0, 3, 243, 147>>
```

### Decoding

```elixir
iex> XDR.HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{:ok, {%XDR.HyperInt{datum: 258963}, <<>>}}

iex> XDR.HyperInt.decode_xdr!(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{%XDR.HyperInt{datum: 258963}, <<>>}
```