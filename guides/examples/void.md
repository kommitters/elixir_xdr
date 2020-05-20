# Void

 Represents the void types or nil in elixir case

## Usage

### Encoding
```elixir 
iex> XDR.Void.new(nil) |> XDR.Void.encode_xdr()
{:ok, <<>>}

iex> XDR.Void.new(nil) |> XDR.Void.encode_xdr!()
<<>>
```
### Decoding
```elixir 
iex> XDR.Void.decode_xdr(<<>>)
{:ok, {nil, <<>>}}

iex> XDR.Void.decode_xdr!(<<>>)
{nil, <<>>}
```