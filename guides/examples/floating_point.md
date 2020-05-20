# Floating Point

Represents single-precision float values (32 bits, 4 bytes)
## Usage

### Encoding

```elixir 
iex> XDR.Float.new(3.46) |> XDR.Float.encode_xdr()
{:ok, <<64, 93, 112, 164>>}

iex> XDR.Float.new(258963) |> XDR.Float.encode_xdr!()
<<64, 93, 112, 164>>
```

### Decoding

```elixir
iex> XDR.Float.decode_xdr(<<64, 93, 112, 164>>)
{:ok, {%XDR.Float{float: 3.4600000381469727}, <<>>}}

iex> XDR.Float.decode_xdr!(<<64, 93, 112, 164>>)
{%XDR.Float{float: 3.4600000381469727}, <<>>}
```