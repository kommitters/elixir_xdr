# Optional

 Represents the values that can be nil or not

## Usage

### Encoding
```elixir 
iex> XDR.Optional.new(nil) |> XDR.Optional.encode_xdr()
{:ok, <<0, 0, 0, 0>>}


iex> XDR.Int.new(56) |> XDR.Optional.new() |> XDR.Optional.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 56>>}

iex> XDR.Int.new(56) |> XDR.Optional.new() |> XDR.Optional.encode_xdr!()
<<0, 0, 0, 1, 0, 0, 0, 56>>
```
### Decoding
```elixir 
iex> XDR.Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 56>>, %{type: XDR.Int})
{:ok, {%XDR.Optional{type: %XDR.Int{datum: 56}}, <<>>}}

iex> XDR.Optional.decode_xdr!(<<0, 0, 0, 1, 0, 0, 0, 56>>, %{type: XDR.Int})
{%XDR.Optional{type: %XDR.Int{datum: 56}}, <<>>}

iex> XDR.Optional.decode_xdr!(<<0, 0, 0, 0>>, %{type: XDR.Int})
{nil, <<>>}
```