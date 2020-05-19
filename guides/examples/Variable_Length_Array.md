# Variable-Length Array
 
Represents a variable-length array which contains the same type of elements

## Usage

### Encoding

```elixir 
iex> XDR.VariableArray.new([1,2,3], XDR.Int) |> XDR.VariableArray.encode_xdr()
{:ok, <<0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex> XDR.VariableArray.new(["The", "little", "prince"], XDR.String) |> XDR.VariableArray.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108,
  101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```

### Decoding

```elixir
iex> XDR.VariableArray.decode_xdr(<<0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>, 
...> %{type: XDR.Int, max_length: 3})
{:ok, {[%XDR.Int{datum: 1}, %XDR.Int{datum: 2}, %XDR.Int{datum: 3}], <<>>}}

iex> XDR.VariableArray.decode_xdr!(<<0, 0, 0, 3, 0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105,
...> 116, 116, 108, 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>, 
...> %{type: XDR.String, length: 3})
{[
   %XDR.String{max_length: 4294967295, string: "The"},
   %XDR.String{max_length: 4294967295, string: "little"},
   %XDR.String{max_length: 4294967295, string: "prince"}
 ], <<>>}
```