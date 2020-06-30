# XDR.Bool - Boolean
Boolean is an Enumeration implementation that allows us to create boolean types. An XDR Boolean type is a Enumeration with the keyword list `[false: 0, true: 1]` as declarations.

[Boolean - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.4)

## Usage

### Encoding

```elixir
iex(1)> XDR.Bool.new(true) |> XDR.Bool.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex(1)> XDR.Bool.new(true) |> XDR.Bool.encode_xdr!()
<<0, 0, 0, 0>>
```

### Decoding

```elixir
iex(1)> XDR.Bool.decode_xdr(<<0, 0, 0, 1>>)
{:ok, {%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}}

iex(1)> XDR.Bool.decode_xdr!(<<0, 0, 0, 1>>)
{%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
```

### Custom Boolean example

```elixir
  defmodule CustomBoolean do

    @type t :: XDR.Bool.t()

    defdelegate new(bool_value), to: XDR.Bool
    defdelegate encode_xdr(bool), to: XDR.Bool
    defdelegate encode_xdr!(bool), to: XDR.Bool
    defdelegate decode_xdr(bytes), to: XDR.Bool
    defdelegate decode_xdr!(bytes), to: XDR.Bool
  end
```

```elixir
# Encode
CustomBoolean.new(true) |> CustomBoolean.encode_xdr()

# Decode
CustomBoolean.decode_xdr(<<0, 0, 0, 1>>)
```
