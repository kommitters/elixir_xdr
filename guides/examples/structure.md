# XDR.Struct - Structure
Represent a collection of fields, possibly of different data types, typically in fixed number and sequence.

[Structure - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.14)

## Usage

### Encoding

```elixir 
iex(1)> name = XDR.String.new("The little prince")
%XDR.String{max_length: 4294967295, string: "The little prince"}
iex(2)> size = XDR.Int.new(298)
%XDR.Int{datum: 298}
iex(3)> Struct.new([name: name, size: size]) |> Struct.encode_xdr()
{:ok, <<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>}

iex(1)> name = XDR.String.new("The little prince")
%XDR.String{max_length: 4294967295, string: "The little prince"}
iex(2)> size = XDR.Int.new(298)
%XDR.Int{datum: 298}
iex(3)> XDR.Struct.new([name: name, size: size]) |> XDR.Struct.encode_xdr!()
<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>
```

### Decoding

```elixir
iex(1)> struct_spec = XDR.Struct.new([name: XDR.String, size: XDR.Int])
iex(2)> XDR.Struct.decode_xdr(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>, struct_spec)
{:ok, {%XDR.Struct{components: [name: %XDR.String{max_length: 4294967295, string: "The little prince"}, size: %XDR.Int{datum: 298}]}, ""}}

iex(1)> struct_spec = XDR.Struct.new([name: XDR.String, size: XDR.Int])
iex(2)> XDR.Struct.decode_xdr!(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>, struct_spec)
{%XDR.Struct{components: [name: %XDR.String{max_length: 4294967295, string: "The little prince"}, size: %XDR.Int{datum: 298}]}, ""}
```

### Custom Structure example

```elixir
  defmodule CustomStruct do

    @struct_spec [name: XDR.String, age: XDR.UInt]

    @type t :: Struct.t()

    @spec new(params :: keyword() | struct()) :: t
    def new(params), do: Struct.new(params)

    @spec spec() :: t
    defp spec(), do: new(@struct_spec)

    defdelegate encode_xdr(struct), to: Struct
    defdelegate encode_xdr!(struct), to: Struct
    defdelegate decode_xdr(bytes, struct \\ spec()), to: Struct
    defdelegate decode_xdr!(bytes, struct \\ spec()), to: Struct
  end
```

```elixir
# Encode
[name: "John Doe", age: %XDR.UInt{datum: 32}] |> CustomStruct.new() |> CustomStruct.encode_xdr()

# Decode
CustomStruct.decode_xdr!(<<0, 0, 2, 43, 1, 2, 3, 52>>)
```
