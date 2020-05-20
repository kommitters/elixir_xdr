# String
 
Represents string values with max size `4294967295`

## Usage

### Encoding

```elixir 
iex> XDR.String.new("The little prince") |> XDR.String.encode_xdr()
{:ok, <<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
 105, 110, 99, 101, 0, 0, 0>>}

iex> XDR.String.new("The little prince", 17) |> XDR.String.encode_xdr!()
<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
  105, 110, 99, 101, 0, 0, 0>>
```

### Decoding

```elixir
iex> XDR.String.decode_xdr(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116,
 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>)
{:ok, {%XDR.String{max_length: 4294967295, string: "The little prince"}, <<>>}}

iex> XDR.String.decode_xdr!(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116,
 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>)
{%XDR.String{max_length: 4294967295, string: "The little prince"}, <<>>}
```