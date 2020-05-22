# Fixed-Length Array
 
Represents a Fixed-Length array which contains the same type of elements

## Usage

### Encoding

```elixir 
iex> XDR.FixedArray.new([1,2,3], XDR.Int, 3) |> XDR.FixedArray.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex> XDR.FixedArray.new(["The", "little", "prince"], XDR.String, 3) |> XDR.FixedArray.encode_xdr!()
<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0,
  0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```

### Decoding

```elixir
iex> XDR.FixedArray.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>, %{type: XDR.Int, length: 3})
{:ok, {[%XDR.Int{datum: 1}, %XDR.Int{datum: 2}, %XDR.Int{datum: 3}], <<>>}}

iex> XDR.FixedArray.decode_xdr!(<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108,
 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>, %{type: XDR.String, length: 3})
{[
   %XDR.String{max_length: 4294967295, string: "The"},
   %XDR.String{max_length: 4294967295, string: "little"},
   %XDR.String{max_length: 4294967295, string: "prince"}
 ], <<>>}
```