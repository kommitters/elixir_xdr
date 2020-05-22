# Elixir XDR
![Build Badge](https://img.shields.io/github/workflow/status/kommitters/elixir_xdr/ElixirCI/master?style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/elixir_xdr?style=for-the-badge)](https://coveralls.io/github/kommitters/elixir_xdr)
[![Version Badge](https://img.shields.io/hexpm/v/elixir_xdr?style=for-the-badge)](https://hexdocs.pm/elixir_xdr)
![Downloads Badge](https://img.shields.io/hexpm/dt/elixir_xdr?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/elixir_xdr.svg?style=for-the-badge)](https://github.com/kommitters/elixir_xdr/blob/master/LICENSE.md)

Process XDR types based on the [RFC4506](https://www.ietf.org/rfc/rfc4506.txt). Extend with ease to other XDR types.

## Installation
[Available in Hex](https://hex.pm/packages/elixir_xdr), Add `elixir_xdr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_xdr, "~> 0.1.0"}
  ]
end
```

## Implemented types
The following XDR types are completely implemented in this library:

```elixir
# Basic types
XDR.Int                  # Section 4.1
XDR.UInt                 # Section 4.2
XDR.Bool                 # Section 4.4
XDR.HyperInt             # Section 4.5
XDR.HyperUInt            # Section 4.5
XDR.Float                # Section 4.6
XDR.DoubleFloat          # Section 4.7
XDR.Void                 # Section 4.16

# Complex types
XDR.Enum                 # Section 4.3
XDR.FixedOpaque          # Section 4.9
XDR.VariableOpaque       # Section 4.10
XDR.String               # Section 4.11
XDR.FixedArray           # Section 4.12
XDR.VariableArray        # Section 4.13
XDR.Struct               # Section 4.14
XDR.Union                # Section 4.15
XDR.Optional             # Section 4.19
```

**The following types were not implemented**
```
XDR.QuadFloat 	         # Section 4.8, not supported for 128-byte size.
XDR.Const 		         # Section 4.17, can be replaced with elixir constants.
XDR.Typedef 			 # Section 4.18, may be implemented with elixir modules. More info bellow in this guide.
```

## Better without macros

`It is an Open Source project, not a code that only I understand`

Macros are harder to write than ordinary Elixir functions, implementing them increases the code complexity which is not good especially if you are planning to build an Open Source code easy to understand to everyone. We decided to go without macros, we want to let everyone to expand or implement their own XDR types with a clear model based on Elixir functions.

## How to implement an XDR type?
**Behavior is the key**. When implementing a new XDR type follow this [Behavior's Declaration](https://github.com/kommitters/elixir_xdr/blob/develop/lib/xdr/declaration.ex).

## Decoding output
Encoded binaries may overflow the byte(s) size. That's why the returning value for decoding functions is set to be a tuple. Second element holds the remaining binary after decoding. **This applies to all XDR types**.
```elixir
iex> XDR.Int.decode_xdr!(<<0, 0, 4, 210, 5>>)
{%XDR.Int{datum: 1234}, <<5>>}
```

## Usage examples
As mentioned before all the XDR types follow the same [Behavior's Declaration](https://github.com/kommitters/elixir_xdr/blob/develop/lib/xdr/declaration.ex)

### Integer
For encoding integers use `encode_xdr/2` or use the raising version of the function `encode_xdr!/2`.
```elixir
iex> XDR.Int.new(1234) |> XDR.Int.encode_xdr()
{:ok, <<0, 0, 4, 210>>}

iex> XDR.Int.new(1234) |> XDR.Int.encode_xdr!()
<<0, 0, 4, 210>>
```
For decoding use `decode_xdr/2` or `decode_xdr!/2`.
```elixir
iex> XDR.Int.decode_xdr(<<0, 0, 4, 210>>)
{:ok, {%XDR.Int{datum: 1234}, <<>>}}

iex> XDR.Int.decode_xdr!(<<0, 0, 4, 210>>)
{%XDR.Int{datum: 1234}, <<>>}
```

### Unsigned Integer

Represents integer values in a range of `[0, 4294967295]`.

For encoding
```elixir
iex> XDR.UInt.new(564) |> XDR.UInt.encode_xdr()
{:ok, <<0, 0, 2, 52>>}

iex> XDR.UInt.new(564) |> XDR.UInt.encode_xdr!()
<<0, 0, 2, 52>>

```

For decoding
```elixir
iex> XDR.UInt.decode_xdr(<<0, 0, 2, 52>>)
{:ok, {%XDR.UInt{datum: 564}, <<>>}}

iex> XDR.UInt.decode_xdr!(<<0, 0, 2, 52>>)
{%XDR.UInt{datum: 564}, <<>>}
```

### Enumeration

 Represents subsets of integers.

**Implementation**

Enums are keywords lists containing a set of **declarations (statically defined)** and a **identifier** with the key of the selected declaration. The [XDR.Bool](https://github.com/kommitters/elixir_xdr/blob/develop/lib/xdr/bool.ex) is a clear example of an Enum implementation.

```elixir
declarations = [false: 0, true: 1]
```
Now, you could decide the key to select

For encoding
```elixir 
iex> XDR.Enum.new([false: 0, true: 1], :false) |> XDR.Enum.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex> XDR.Enum.new([false: 0, true: 1], :true) |> XDR.Enum.encode_xdr!()
<<0, 0, 0, 1>>
```

For decoding
```elixir
iex> XDR.Enum.decode_xdr(<<0, 0, 0, 1>>, %{declarations: [false: 0, true: 1]})
{:ok, {%XDR.Enum{declarations: [false: 0, true: 1], identifier: true}, <<>>}}

iex> XDR.Enum.decode_xdr!(<<0, 0, 0, 1>>, %{declarations: [false: 0, true: 1]})
{%XDR.Enum{declarations: [false: 0, true: 1], identifier: true}, <<>>}
```

### Boolean
Boolean is an Enum implementation that allows us to create boolean types

```elixir
iex> XDR.Bool.new(true) |> XDR.Bool.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex> XDR.Bool.new(true) |> XDR.Bool.encode_xdr!()
<<0, 0, 0, 0>>
```
For decoding the binary use `decode_xdr/2` or `decode_xdr!/2`..
```elixir
iex> XDR.Bool.decode_xdr(<<0, 0, 0, 1>>)
{:ok, {%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}}

iex> XDR.Bool.decode_xdr!(<<0, 0, 0, 1>>)
{%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
```

### Hyper Integer

Represents integer values in a range of `[-9223372036854775808, 9223372036854775807]`

For encoding

```elixir 
iex> XDR.HyperInt.new(258963) |> XDR.HyperInt.encode_xdr()
{:ok, <<0, 0, 0, 0, 0, 3, 243, 147>>}

iex> XDR.HyperInt.new(258963) |> XDR.HyperInt.encode_xdr!()
<<0, 0, 0, 0, 0, 3, 243, 147>>
```
For encoding
```elixir
iex> XDR.HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{:ok, {%XDR.HyperInt{datum: 258963}, <<>>}}

iex> XDR.HyperInt.decode_xdr!(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{%XDR.HyperInt{datum: 258963}, <<>>}
```

### Unsigned Hyper Integer

Represents integer values in a range of `[0, 18446744073709551615]`

For encoding
```elixir 
iex> XDR.HyperUInt.new(258963) |> XDR.HyperUInt.encode_xdr()
{:ok, <<0, 0, 0, 0, 0, 3, 243, 147>>}

iex> XDR.HyperUInt.new(258963) |> XDR.HyperUInt.encode_xdr!()
<<0, 0, 0, 0, 0, 3, 243, 147>>
```
For decoding
```elixir
iex> XDR.HyperUInt.decode_xdr(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{:ok, {%XDR.HyperUInt{datum: 258963}, <<>>}}

iex> XDR.HyperUInt.decode_xdr!(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{%XDR.HyperUInt{datum: 258963}, <<>>}
```

### Floating Point

Represents single-precision float values (32 bits, 4 bytes)

For encoding
```elixir 
iex> XDR.Float.new(3.46) |> XDR.Float.encode_xdr()
{:ok, <<64, 93, 112, 164>>}

iex> XDR.Float.new(258963) |> XDR.Float.encode_xdr!()
<<64, 93, 112, 164>>
```
For decoding
```elixir
iex> XDR.Float.decode_xdr(<<64, 93, 112, 164>>)
{:ok, {%XDR.Float{float: 3.4600000381469727}, <<>>}}

iex> XDR.Float.decode_xdr!(<<64, 93, 112, 164>>)
{%XDR.Float{float: 3.4600000381469727}, <<>>}
```

### Double-Floating Point

Represents Double-precision float values (64 bits, 8 bytes)

For encoding
```elixir 
iex> XDR.DoubleFloat.new(3.46) |> XDR.DoubleFloat.encode_xdr()
{:ok, <<64, 11, 174, 20, 122, 225, 71, 174>>}

iex> XDR.DoubleFloat.new(258963) |> XDR.DoubleFloat.encode_xdr!()
<<64, 11, 174, 20, 122, 225, 71, 174>>
```
For decoding
```elixir
iex> XDR.DoubleFloat.decode_xdr(<<64, 11, 174, 20, 122, 225, 71, 174>>)
{:ok, {%XDR.DoubleFloat{float: 3.46}, <<>>}}

iex> XDR.DoubleFloat.decode_xdr!(<<64, 11, 174, 20, 122, 225, 71, 174>>)
{:ok, {%XDR.DoubleFloat{float: 3.46}, <<>>}}
```

### Fixed-Length Opaque
FixedOpaque is used for fixed-length uninterpreted data that needs to be passed among machines, in other words, let's think on a string that must match a fixed length.

```elixir
iex> ComplementBinarySize.new(<<1,2,3,4,5>>) |> ComplementBinarySize.encode_xdr()
{:ok, <<1, 2, 3, 4, 5, 0, 0, 0>>}
```
An example is available here: [FixedOpaque Type](https://github.com/kommitters/elixir_xdr/wiki/FixedOpaque-example).

### Variable-Length Opaque

Represents a sequence of n (numbered 0 through n-1) arbitrary bytes to be the number n encoded as an unsigned integer

For encoding
```elixir 
iex> XDR.VariableOpaque.new(<<1, 2, 3, 4, 5>>) |> XDR.VariableOpaque.encode_xdr()
{:ok, <<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>}

iex> XDR.VariableOpaque.new(<<1, 2, 3>>, 3) |> XDR.VariableOpaque.encode_xdr!()
<<0, 0, 0, 3, 1, 2, 3, 0>>
```
For decoding
```elixir
iex> XDR.VariableOpaque.decode_xdr(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{:ok, {%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}}

iex> XDR.VariableOpaque.decode_xdr!(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}
```

### String
For econding strings.
```elixir
iex> XDR.String.new("The little prince") |> XDR.String.encode_xdr()
{:ok,
 <<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
   105, 110, 99, 101, 0, 0, 0>>}

iex> XDR.String.new("The little prince") |> XDR.String.encode_xdr!()
<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
  105, 110, 99, 101, 0, 0, 0>>
```
For decoding strings.
```elixir
iex> XDR.String.decode_xdr(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
  105, 110, 99, 101, 0, 0, 0>>)
{:ok, {%XDR.String{max_length: 4294967295, string: "The little prince"}, ""}}

iex> XDR.String.decode_xdr!(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
  105, 110, 99, 101, 0, 0, 0>>)
{%XDR.String{max_length: 4294967295, string: "The little prince"}, ""}
```

### Fixed-Length Array
 
Represents a Fixed-Length array that contains the same type of elements

For encoding
```elixir 
iex> XDR.FixedArray.new([1,2,3], XDR.Int, 3) |> XDR.FixedArray.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex> XDR.FixedArray.new(["The", "little", "prince"], XDR.String, 3) |> XDR.FixedArray.encode_xdr!()
<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0,
  0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```
For decoding
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

### Variable-Length Array
 
Represents a variable-length array which contains the same type of elements

For encoding
```elixir 
iex> XDR.VariableArray.new([1,2,3], XDR.Int) |> XDR.VariableArray.encode_xdr()
{:ok, <<0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex> XDR.VariableArray.new(["The", "little", "prince"], XDR.String) |> XDR.VariableArray.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108,
  101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```
For decoding
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

### Structure
```elixir
iex(1)> name = XDR.String.new("The little prince")
%XDR.String{max_length: 4294967295, string: "The little prince"}

iex(2)> size = XDR.Int.new(298)
%XDR.Int{datum: 298}

iex(3)> Book.new(name, size) |> Book.encode_xdr()
{:ok,
 <<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114,
   105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>}
```
An example is available here: [Struct Type](https://github.com/kommitters/elixir_xdr/wiki/Struct-example).

### Union
A union is a type composed of a discriminant **(Statement)** followed by a type selected from a set of prearranged types **(UnionStatement)**. The type of discriminant is either "Int", "Unsigned Int", or an Enumerated type, such as "Bool". The **(UnionStatement)** types are called "arms" of the union and are preceded by the value of the discriminant that implies their encoding.

```elixir
iex(1)> XDR.UnionStatement.new(:ST_NOMINATE) |> XDR.UnionStatement.encode_xdr()
{:ok, <<0, 0, 0, 3, 64, 93, 112, 164>>}

iex(3)> XDR.UnionStatement.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)
{:ok, {{:ST_NOMINATE, %XDR.Float{float: 3.4600000381469727}}, ""}}
```

An example is available here: [Union Example](https://github.com/kommitters/elixir_xdr/wiki/Union-example)

### Void

Represents the void types or nil in elixir case

For encoding
```elixir 
iex> XDR.Void.new(nil) |> XDR.Void.encode_xdr()
{:ok, <<>>}

iex> XDR.Void.new(nil) |> XDR.Void.encode_xdr!()
<<>>
```
For decoding
```elixir 
iex> XDR.Void.decode_xdr(<<>>)
{:ok, {nil, <<>>}}

iex> XDR.Void.decode_xdr!(<<>>)
{nil, <<>>}
```

### Optional
Think that you are filling out a form and it has optional fields such as the phone number if you do not want to fill this field you can leave it empty and the field will have a nil value, on the contrary, if you want to fill it out you can do it and it will take the indicated value

```elixir
iex(1)> XDR.String.new("phone number") |> OptionalString.new() |> OptionalString.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 12, 112, 104, 111, 110, 101, 32, 110, 117, 109, 98, 101, 114>>}

iex(2)> OptionalString.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 12, 112, 104, 111, 110, 101, 32, 110, 117, 109, 98, 101, 114>>)
{:ok,
 {%XDR.Optional{type: %XDR.String{max_length: 4294967295, string: "phone number"}}, ""}}
iex(3)> OptionalString.new(nil) |> OptionalString.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex(4)> OptionalString.decode_xdr(<<0, 0, 0, 0>>)
{:ok, {nil, ""}}
```

An example is available here: [Optional Type Example](https://github.com/kommitters/elixir_xdr/wiki/Optional-example)

## Contributing and Development
See [CONTRIBUTING.md](https://github.com/kommitters/elixir_xdr/blob/master/CONTRIBUTING.md)
for guidance on how to develop for this library.

Bug reports and pull requests are welcome on GitHub at https://github.com/kommitters/elixir_xdr.

Everyone is welcome to participate in the project.

## Changelog
See the [CHANGELOG](https://github.com/kommitters/elixir_xdr/blob/master/CHANGELOG.md) for versions details.

## License
See [LICENSE](https://github.com/kommitters/elixir_xdr/blob/master/LICENSE) for details.

## Credits
Made with 💙 from [kommit](https://kommit.co)