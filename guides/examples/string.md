# XDR.String - String
Represents a string of n (numbered 0 through n-1) ASCII bytes to be the number n encoded as an unsigned integer (as described above), and followed by the n bytes of the string. If the maximum length is not specified, it is assumed to be 2<sup>32</sup> - 1.

[String - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.11)

## Usage

### Encoding

```elixir 
iex(1)> XDR.String.new("The little prince") |> XDR.String.encode_xdr()
{:ok, <<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>}

iex(1)> XDR.String.new("The little prince") |> XDR.String.encode_xdr!()
<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>
```

### Decoding

```elixir
iex(1)> XDR.String.decode_xdr(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>)
{:ok, {%XDR.String{max_length: 4294967295, string: "The little prince"}, ""}}

iex(1)> XDR.String.decode_xdr!(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>)
{%XDR.String{max_length: 4294967295, string: "The little prince"}, ""}
```

### Custom String example

```elixir
  defmodule CustomString do

    @max_length 28

    @type t :: XDR.String.t()

    @spec new(text :: binary()) :: t
    def new(text \\ nil), do: XDR.String.new(text, @max_length)

    defdelegate encode_xdr(text), to: XDR.String
    defdelegate encode_xdr!(text), to: XDR.String
    defdelegate decode_xdr(bytes, string \\ new()), to: XDR.String
    defdelegate decode_xdr!(bytes, string \\ new()), to: XDR.String
  end
```

```elixir
# Encode
CustomString.new("Example") |> CustomString.encode_xdr()

# Decode
CustomString.decode_xdr!(<<0, 0, 0, 7, 69, 120, 97, 109, 112, 108, 101, 0>>)
```
