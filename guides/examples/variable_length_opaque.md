# XDR.VariableOpaque - Variable-Length Opaque
Represents a sequence of n (numbered 0 through n-1) arbitrary bytes to be the number n encoded as an unsigned integer. If the maximum length is not specified, it is assumed to be 2<sup>32</sup> - 1, the maximum length.

[Variable-Length Opaque - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.10)

### Encoding

```elixir 
iex(1)> XDR.VariableOpaque.new(<<1, 2, 3, 4, 5>>, 5) |> XDR.VariableOpaque.encode_xdr()
{:ok, <<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>}

iex(1)> XDR.VariableOpaque.new(<<1, 2, 3>>, 3) |> XDR.VariableOpaque.encode_xdr!()
<<0, 0, 0, 3, 1, 2, 3, 0>>
```

### Decoding

```elixir
iex(1)> XDR.VariableOpaque.decode_xdr(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{:ok, {%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}}

iex(1)> XDR.VariableOpaque.decode_xdr!(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}
```

### Custom Variable-Length Opaque example

```elixir
  defmodule CustomVariableOpaque do

    @type t :: XDR.VariableOpaque.t()

    @max_size 64

    @spec new(opaque :: binary()) :: t
    def new(opaque \\ nil, max_size \\ @max_size) when max_size <= @max_size do
      XDR.VariableOpaque.new(opaque, max_size)
    end

    defdelegate encode_xdr(variable_opaque), to: XDR.VariableOpaque
    defdelegate encode_xdr!(variable_opaque), to: XDR.VariableOpaque
    defdelegate decode_xdr(bytes, variable_opaque \\ new()), to: XDR.VariableOpaque
    defdelegate decode_xdr!(bytes, variable_opaque \\ new()), to: XDR.VariableOpaque
  end
```

```elixir
# Encode
CustomVariableOpaque.new(<<1, 2, 3, 4, 5, 6, 7>>) |> CustomVariableOpaque.encode_xdr()

# Decode
CustomVariableOpaque.decode_xdr!(<<1, 2, 3, 4, 5, 6, 7>>)
```
