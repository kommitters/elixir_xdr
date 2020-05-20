# Boolean

 It is an Enum implementation to represent the boolean values

## Usage

### Encoding

```elixir 
iex> XDR.Bool.new(false) |> XDR.Bool.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex> XDR.Bool.new(true) |> XDR.Bool.encode_xdr!()
<<0, 0, 0, 1>>
```

### Decoding

```elixir
iex> XDR.Bool.decode_xdr(<<0, 0, 0, 0>>)
{:ok, {%XDR.Bool{declarations: [false: 0, true: 1], identifier: false}, <<>>}}

iex> XDR.Bool.decode_xdr!(<<0, 0, 0, 1>>)
{%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, <<>>}
```