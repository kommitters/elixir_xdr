# Unsigned Integer

 Represents integer values in the range `[0, 4294967295]`.

## Usage

### Encoding
```elixir
iex> XDR.UInt.new(564) |> XDR.UInt.encode_xdr()
{:ok, <<0, 0, 2, 52>>}

iex> XDR.UInt.new(564) |> XDR.UInt.encode_xdr!()
<<0, 0, 2, 52>>

```

### Decoding
```elixir
iex> XDR.UInt.decode_xdr(<<0, 0, 2, 52>>)
{:ok, {%XDR.UInt{datum: 564}, <<>>}}

iex> XDR.UInt.decode_xdr!(<<0, 0, 2, 52>>)
{%XDR.UInt{datum: 564}, <<>>}
```