# XDR.VariableArray - Variable-Length Array
Represents a variable-length array that contains elements with the same type. If the maximum length is not specified, it is assumed to be 2<sup>32</sup> - 1.

[Variable-Length Array - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.13)

## Usage

### Encoding

```elixir 
iex(1)> XDR.VariableArray.new([1,2,3], XDR.Int) |> XDR.VariableArray.encode_xdr()
{:ok, <<0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex(1)> XDR.VariableArray.new(["The", "little", "prince"], XDR.String) |> XDR.VariableArray.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```

### Decoding

```elixir
iex(1)> XDR.VariableArray.decode_xdr(<<0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>, 
...> %{type: XDR.Int, max_length: 3})
{:ok, {[%XDR.Int{datum: 1}, %XDR.Int{datum: 2}, %XDR.Int{datum: 3}], <<>>}}

iex(1)> XDR.VariableArray.decode_xdr!(<<0, 0, 0, 3, 0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105,
...> 116, 116, 108, 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>, 
...> %{type: XDR.String, length: 3})
{[
   %XDR.String{max_length: 4294967295, string: "The"},
   %XDR.String{max_length: 4294967295, string: "little"},
   %XDR.String{max_length: 4294967295, string: "prince"}
 ], <<>>}
```

### Custom Variable-Length Array example

```elixir
  defmodule CustomVariableArray do

    @max_length 100

    @type t :: XDR.VariableArray.t()

    @spec new(list_items :: list(XDR.String.t())) :: t
    def new(list_items \\ []) when is_list(list_items),
      do: XDR.VariableArray.new(list_items, XDR.String, @max_length)

    defdelegate encode_xdr(variable_array), to: XDR.VariableArray
    defdelegate encode_xdr!(variable_array), to: XDR.VariableArray
    defdelegate decode_xdr(bytes, variable_array \\ new()), to: XDR.VariableArray
    defdelegate decode_xdr!(bytes, variable_array \\ new()), to: XDR.VariableArray
  end
```

```elixir
# Encode
CustomVariableArray.new(["item 1", "item 2"]) |> CustomVariableArray.encode_xdr()

# Decode
CustomVariableArray.decode_xdr!(<<0, 0, 2, 52>>)
```
