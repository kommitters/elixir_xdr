# XDR.FixedArray - Fixed-Length Array
Represents a fixed-length array that contains elements with the same type.

[Fixed-Length Array - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.12)

## Usage

### Encoding

```elixir 
iex(1)> XDR.FixedArray.new([1,2,3], XDR.Int, 3) |> XDR.FixedArray.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex(1)> XDR.FixedArray.new(["The", "little", "prince"], XDR.String, 3) |> XDR.FixedArray.encode_xdr!()
<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0,
  0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```

### Decoding

```elixir
iex(1)> XDR.FixedArray.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>, %{type: XDR.Int, length: 3})
{:ok, {[%XDR.Int{datum: 1}, %XDR.Int{datum: 2}, %XDR.Int{datum: 3}], <<>>}}

iex(1)> XDR.FixedArray.decode_xdr!(<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108,
 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>, %{type: XDR.String, length: 3})
{[
   %XDR.String{max_length: 4294967295, string: "The"},
   %XDR.String{max_length: 4294967295, string: "little"},
   %XDR.String{max_length: 4294967295, string: "prince"}
 ], <<>>}
```

### Custom Fixed-Length Array example

```elixir
  defmodule CustomFixedArray do

    @length 3

    @type t :: XDR.FixedArray.t()

    @spec new(list_items :: list(XDR.String.t())) :: t
    def new(list_items \\ []) when is_list(list_items),
      do: XDR.FixedArray.new(list_items, XDR.String, @length)

    defdelegate encode_xdr(fixed_array), to: XDR.FixedArray
    defdelegate encode_xdr!(fixed_array), to: XDR.FixedArray
    defdelegate decode_xdr(bytes, fixed_array \\ new()), to: XDR.FixedArray
    defdelegate decode_xdr!(bytes, fixed_array \\ new()), to: XDR.FixedArray
  end
```

```elixir
# Encode
CustomFixedArray.new(["item 1", "item 2", "item 3"]) |> CustomFixedArray.encode_xdr()

# Decode
CustomFixedArray.decode_xdr!(<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>)
```
