# Variable-Length Opaque

Represents a sequence of n (numbered 0 through n-1) arbitrary bytes to be the number n encoded as an unsigned integer

## Usage

### Encoding

```elixir 
iex> XDR.VariableOpaque.new(<<1, 2, 3, 4, 5>>) |> XDR.VariableOpaque.encode_xdr()
{:ok, <<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>}

iex> XDR.VariableOpaque.new(<<1, 2, 3>>, 3) |> XDR.VariableOpaque.encode_xdr!()
<<0, 0, 0, 3, 1, 2, 3, 0>>
```

### Decoding

```elixir
iex> XDR.VariableOpaque.decode_xdr(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{:ok, {%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}}

iex> XDR.VariableOpaque.decode_xdr!(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}
```