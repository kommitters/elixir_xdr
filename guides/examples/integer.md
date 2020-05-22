# Integer

 Represents integer values in the range `[-2147483648, 2147483647]`.

## Usage

### Encoding
```elixir
iex> XDR.Int.new(564) |> XDR.Int.encode_xdr()
{:ok, <<0, 0, 2, 52>>}

iex> XDR.Int.new(564) |> XDR.Int.encode_xdr!()
<<0, 0, 2, 52>>

```

### Decoding
```elixir
iex> XDR.Int.decode_xdr(<<0, 0, 2, 52>>)
{:ok, {%XDR.Int{datum: 564}, <<>>}}

iex> XDR.Int.decode_xdr!(<<0, 0, 2, 52>>)
{%XDR.Int{datum: 564}, <<>>}
```