# Structure
 
Represents a data set which could contain any XDR type

## Usage

### Encoding

```elixir 
iex> XDR.Struct.new([name: XDR.String.new("Jhon Doe"), age: XDR.Int.new(27)]) 
...> |>XDR.Struct.encode_xdr()
{:ok, <<0, 0, 0, 8, 74, 104, 111, 110, 32, 68, 111, 101, 0, 0, 0, 27>>}

iex> XDR.Struct.new([name: XDR.String.new("Jhon Doe"), age: XDR.Int.new(27)]) 
...> |>XDR.Struct.encode_xdr()
<<0, 0, 0, 8, 74, 104, 111, 110, 32, 68, 111, 101, 0, 0, 0, 27>>
```

### Decoding

```elixir
iex> XDR.Struct.decode_xdr(<<0, 0, 0, 8, 74, 104, 111, 110, 32, 68, 111, 101, 0, 0, 0, 27>>, 
...> %{components: [name: XDR.String, age: XDR.Int]})
{:ok,
 {%XDR.Struct{
    components: [
      name: %XDR.String{max_length: 4294967295, string: "Jhon Doe"},
      age: %XDR.Int{datum: 27}
    ]
  }, <<>>}}

iex> XDR.Struct.decode_xdr!(<<0, 0, 0, 8, 74, 104, 111, 110, 32, 68, 111, 101, 0, 0, 0, 27>>,
...> %{components: [name: XDR.String, age: XDR.Int]})
{%XDR.Struct{
   components: [
     name: %XDR.String{max_length: 4294967295, string: "Jhon Doe"},
     age: %XDR.Int{datum: 27}
   ]
 }, <<>>}
```