# Elixir XDR
![Build Badge](https://img.shields.io/github/actions/workflow/status/kommitters/elixir_xdr/ci.yml?branch=main&style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/elixir_xdr?style=for-the-badge)](https://coveralls.io/github/kommitters/elixir_xdr)
[![Version Badge](https://img.shields.io/hexpm/v/elixir_xdr?style=for-the-badge)](https://hexdocs.pm/elixir_xdr)
![Downloads Badge](https://img.shields.io/hexpm/dt/elixir_xdr?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/elixir_xdr.svg?style=for-the-badge)](https://github.com/kommitters/elixir_xdr/blob/master/LICENSE.md)
[![OpenSSF Best Practices](https://img.shields.io/cii/summary/6466?label=openssf%20best%20practices&style=for-the-badge)](https://bestpractices.coreinfrastructure.org/projects/6466)
[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/kommitters/elixir_xdr?label=openssf%20scorecard&style=for-the-badge)](https://api.securityscorecards.dev/projects/github.com/kommitters/elixir_xdr)

XDR is an open data format, specified in [RFC 4506](http://tools.ietf.org/html/rfc4506.html). This library provides a way to decode and encode XDR data from Elixir. Extend with ease to other XDR types.

## Installation
[Available in Hex][hex], Add `elixir_xdr` to your dependencies list in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_xdr, "~> 0.3.9"}
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

The following types were not implemented:
```elixir
XDR.QuadFloat            # Section 4.8, not supported for 128-byte size.
XDR.Const                # Section 4.17, can be replaced with elixir constants.
XDR.Typedef              # Section 4.18, may be implemented with elixir modules. More info bellow in this guide.
```

## Better without macros

`It is an Open Source project, not a code that only I understand.`

Macros are harder to write than ordinary Elixir functions, implementing them increases the code complexity, which is not good, especially if you plan to build an Open Source code that is easy to understand for everyone. We decided to go without macros, we want to let everyone expand or implement their own XDR types with a clear model based on Elixir functions.

## How to implement an XDR type?
**Behaviour is the key**. When implementing a new XDR type, follow this [Behaviour's Declaration](https://github.com/kommitters/elixir_xdr/blob/master/lib/xdr/declaration.ex).

### For Encoding
We use the function `encode_xdr/2` or the bang version `encode_xdr!/2` to encode any XDR type to its XDR binary format.

### For Decoding
We use the function `decode_xdr/2` or the bang version `decode_xdr!/2` to decode any XDR type from an XDR binary format.

In most XDR types, we must pass the `type specification`, it is a struct (or map) with the XDR type attributes that is expected to decode.

```elixir
iex(1)> enum_spec = XDR.Enum.new([false: 0, true: 1], nil) # preferred.
%XDR.Enum{declarations: [false: 0, true: 1], identifier: nil}
iex(2)> XDR.Enum.decode_xdr(<<0, 0, 0, 1>>, enum_spec)

iex(1)> enum_spec = %{declarations: [false: 0, true: 1]}
iex(2)> XDR.Enum.decode_xdr!(<<0, 0, 0, 0>>, enum_spec)
{%XDR.Enum{declarations: [false: 0, true: 1], identifier: false}, <<>>}
```

For all XDR types, encoded binaries may overflow the byte(s) size, that is why the returning value for decoding functions is set to be a tuple. The first element holds the XDR type decoded and the second element holds the remaining binary after decoding.

```elixir
iex(1)> {decoded_part, remaining_part} = XDR.Int.decode_xdr!(<<127, 255, 255, 255, 5>>)
{{%XDR.Int{datum: 2147483647}, <<5>>}}

# decoded_part = %XDR.Int{datum: 2147483647}
# remaining_part = <<5>>
```

## Basic usage examples
As mentioned before, all the XDR types follow the same [Behaviour's Declaration](https://github.com/kommitters/elixir_xdr/blob/master/lib/xdr/declaration.ex)

### XDR.Int - Integer
An XDR signed integer is a 32-bit datum that encodes an integer in the range `[-2_147_483_648, 2_147_483_647]`.

Encoding:
```elixir
iex(1)> XDR.Int.new(1234) |> XDR.Int.encode_xdr()
{:ok, <<0, 0, 4, 210>>}

iex(1)> XDR.Int.new(1234) |> XDR.Int.encode_xdr!()
<<0, 0, 4, 210>>
```

Decoding:
```elixir
iex(1)> XDR.Int.decode_xdr(<<0, 0, 4, 210>>)
{:ok, {%XDR.Int{datum: 1234}, <<>>}}

iex(1)> XDR.Int.decode_xdr!(<<0, 0, 4, 210>>)
{%XDR.Int{datum: 1234}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/integer.html).

### XDR.UInt - Unsigned Integer
An XDR unsigned integer is a 32-bit datum that encodes a non-negative integer in the range `[0, 4_294_967_295]`.

Encoding:
```elixir
iex(1)> XDR.UInt.new(564) |> XDR.UInt.encode_xdr()
{:ok, <<0, 0, 2, 52>>}

iex(1)> XDR.UInt.new(564) |> XDR.UInt.encode_xdr!()
<<0, 0, 2, 52>>

```

Decoding:
```elixir
iex(1)> XDR.UInt.decode_xdr(<<0, 0, 2, 52>>)
{:ok, {%XDR.UInt{datum: 564}, <<>>}}

iex(1)> XDR.UInt.decode_xdr!(<<0, 0, 2, 52>>)
{%XDR.UInt{datum: 564}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/unsigned_integer.html).

### XDR.Enum - Enumeration
Represents subsets of integers.
The Enumeration's declarations are a keyword list of integers (E.g. `[false: 0, true: 1]`).

Encoding:
```elixir
iex(1)> XDR.Enum.new([false: 0, true: 1], :false) |> XDR.Enum.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex(1)> XDR.Enum.new([false: 0, true: 1], :true) |> XDR.Enum.encode_xdr!()
<<0, 0, 0, 1>>
```

Decoding:
```elixir
iex(1)> enum_spec = XDR.Enum.new([false: 0, true: 1], nil)
iex(2)> XDR.Enum.decode_xdr(<<0, 0, 0, 1>>, enum_spec)
{:ok, {%XDR.Enum{declarations: [false: 0, true: 1], identifier: true}, <<>>}}

iex(1)> XDR.Enum.decode_xdr!(<<0, 0, 0, 0>>, %{declarations: [false: 0, true: 1]})
{%XDR.Enum{declarations: [false: 0, true: 1], identifier: false}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/enumeration.html).

### XDR.Bool - Boolean
Boolean is an Enumeration implementation that allows us to create boolean types. An XDR Boolean type is an Enumeration with the keyword list `[false: 0, true: 1]` as declarations.

Encoding:
```elixir
iex(1)> XDR.Bool.new(true) |> XDR.Bool.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex(1)> XDR.Bool.new(true) |> XDR.Bool.encode_xdr!()
<<0, 0, 0, 0>>
```

Decoding:
```elixir
iex(1)> XDR.Bool.decode_xdr(<<0, 0, 0, 1>>)
{:ok, {%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}}

iex(1)> XDR.Bool.decode_xdr!(<<0, 0, 0, 1>>)
{%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
```

More examples [here](https://hexdocs.pm/elixir_xdr/boolean.html).

### XDR.HyperInt - Hyper Integer
It is an extension of the Integer type defined above. Represents a 64-bit (8-byte) integer with values in a range of `[-9_223_372_036_854_775_808, 9_223_372_036_854_775_807]`.

Encoding:
```elixir
iex(1)> XDR.HyperInt.new(9_223_372_036_854_775_807) |> XDR.HyperInt.encode_xdr()
{:ok, <<127, 255, 255, 255, 255, 255, 255, 255>>}

iex(1)> XDR.HyperInt.new(258963) |> XDR.HyperInt.encode_xdr!()
<<0, 0, 0, 0, 0, 3, 243, 147>>
```

Decoding:
```elixir
iex(1)> XDR.HyperInt.decode_xdr(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{:ok, {%XDR.HyperInt{datum: 258963}, <<>>}}

iex(1)> XDR.HyperInt.decode_xdr!(<<127, 255, 255, 255, 255, 255, 255, 255>>)
{%XDR.HyperInt{datum: 9223372036854775807}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/hyper_integer.html).

### XDR.HyperUInt - Unsigned Hyper Integer
It is an extension of the Unsigned Integer type defined above. Represents a 64-bit (8-byte) unsigned integer with values in a range of `[0, 18_446_744_073_709_551_615]`.

Encoding:
```elixir
iex(1)> XDR.HyperUInt.new(258963) |> XDR.HyperUInt.encode_xdr()
{:ok, <<0, 0, 0, 0, 0, 3, 243, 147>>}

iex(1)> XDR.HyperUInt.new(18_446_744_073_709_551_615) |> XDR.HyperUInt.encode_xdr!()
<<255, 255, 255, 255, 255, 255, 255, 255>>
```

Decoding:
```elixir
iex(1)> XDR.HyperUInt.decode_xdr(<<255, 255, 255, 255, 255, 255, 255, 255>>)
{:ok, {%XDR.HyperUInt{datum: 18446744073709551615}, <<>>}}

iex(1)> XDR.HyperUInt.decode_xdr!(<<0, 0, 0, 0, 0, 3, 243, 147>>)
{%XDR.HyperUInt{datum: 258963}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/unsigned_hyper_integer.html).

### XDR.Float - Floating Point
Represents a single-precision float value (32 bits, 4 bytes).

Encoding:
```elixir
iex(1)> XDR.Float.new(3.46) |> XDR.Float.encode_xdr()
{:ok, <<64, 93, 112, 164>>}

iex(1)> XDR.Float.new(-2589) |> XDR.Float.encode_xdr!()
<<197, 33, 208, 0>>
```

Decoding:
```elixir
iex(1)> XDR.Float.decode_xdr(<<64, 93, 112, 164>>)
{:ok, {%XDR.Float{float: 3.4600000381469727}, <<>>}}

iex(1)> XDR.Float.decode_xdr!(<<197, 33, 208, 0>>)
{%XDR.Float{float: -2589.0}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/floating_point.html).

### XDR.DoubleFloat - Double-Floating Point
Represents a Double-precision float value (64 bits, 8 bytes).

Encoding:
```elixir
iex(1)> XDR.DoubleFloat.new(0.333333333333333314829616256247390992939472198486328125) |> XDR.DoubleFloat.encode_xdr()
{:ok, <<63, 213, 85, 85, 85, 85, 85, 85>>}

iex(1)> XDR.DoubleFloat.new(258963) |> XDR.DoubleFloat.encode_xdr!()
<<65, 15, 156, 152, 0, 0, 0, 0>>
```

Decoding:
```elixir
iex(1)> XDR.DoubleFloat.decode_xdr(<<65, 15, 156, 152, 0, 0, 0, 0>>)
{:ok, {%XDR.DoubleFloat{float: 258963.0}, ""}}

iex(1)> XDR.DoubleFloat.decode_xdr!(<<64, 11, 174, 20, 122, 225, 71, 174>>)
{%XDR.DoubleFloat{float: 3.46}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/double_floating_point.html).

### XDR.FixedOpaque - Fixed-Length Opaque
Represents a fixed-length uninterpreted data (This data is called "opaque") that needs to be passed among machines.

In the following examples we will use an opaque of 12-bytes length:

Encoding:
```elixir
iex(1)> XDR.FixedOpaque.new(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, 12) |> XDR.FixedOpaque.encode_xdr()
{:ok, <<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>}

iex(1)> XDR.FixedOpaque.new(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, 12) |> XDR.FixedOpaque.encode_xdr!()
<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>
```

Decoding:
```elixir
iex(1)> XDR.FixedOpaque.decode_xdr(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, %{length: 12})
{:ok, {%XDR.FixedOpaque{length: 12, opaque: <<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>}, ""}}

iex(1)> opaque_spec = XDR.FixedOpaque.new(nil, 12)
iex(2)> XDR.FixedOpaque.decode_xdr!(<<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>, opaque_spec)
{%XDR.FixedOpaque{length: 12, opaque: <<72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 0>>}, ""}
```

More examples [here](https://hexdocs.pm/elixir_xdr/fixed_length_opaque.html).

### XDR.VariableOpaque - Variable-Length Opaque
Represents a sequence of n (numbered 0 through n-1) arbitrary bytes to be the number n encoded as an unsigned integer. If the maximum length is not specified, it is assumed to be 2<sup>32</sup> - 1.

Encoding:
```elixir
iex(1)> XDR.VariableOpaque.new(<<1, 2, 3, 4, 5>>, 5) |> XDR.VariableOpaque.encode_xdr()
{:ok, <<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>}

iex(1)> XDR.VariableOpaque.new(<<1, 2, 3>>, 3) |> XDR.VariableOpaque.encode_xdr!()
<<0, 0, 0, 3, 1, 2, 3, 0>>
```

Decoding:
```elixir
iex(1)> XDR.VariableOpaque.decode_xdr(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{:ok, {%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}}

iex(1)> XDR.VariableOpaque.decode_xdr!(<<0, 0, 0, 5, 1, 2, 3, 4, 5, 0, 0, 0>>, %{max_size: 5})
{%XDR.VariableOpaque{max_size: 5, opaque: <<1, 2, 3, 4, 5>>}, <<>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/variable_length_opaque.html).

### XDR.String - String
Represents a string of n (numbered 0 through n-1) ASCII bytes to be the number n encoded as an unsigned integer (as described above), and followed by the n bytes of the string. If the maximum length is not specified, it is assumed to be 2<sup>32</sup> - 1.

Encoding:
```elixir
iex(1)> XDR.String.new("The little prince") |> XDR.String.encode_xdr()
{:ok, <<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>}

iex(1)> XDR.String.new("The little prince") |> XDR.String.encode_xdr!()
<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>
```

Decoding:
```elixir
iex(1)> XDR.String.decode_xdr(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>)
{:ok, {%XDR.String{max_length: 4294967295, string: "The little prince"}, ""}}

iex(1)> XDR.String.decode_xdr!(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0>>)
{%XDR.String{max_length: 4294967295, string: "The little prince"}, ""}
```

More examples [here](https://hexdocs.pm/elixir_xdr/string.html).

### XDR.FixedArray - Fixed-Length Array
Represents a fixed-length array that contains elements with the same type.

Encoding:
```elixir
iex(1)> XDR.FixedArray.new([1,2,3], XDR.Int, 3) |> XDR.FixedArray.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex(1)> XDR.FixedArray.new(["The", "little", "prince"], XDR.String, 3) |> XDR.FixedArray.encode_xdr!()
<<0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0,
  0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```

Decoding:
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

More examples [here](https://hexdocs.pm/elixir_xdr/fixed_length_array.html).

### XDR.VariableArray - Variable-Length Array
Represents a variable-length array that contains elements with the same type. If the maximum length is not specified, it is assumed to be 2<sup>32</sup> - 1.

Encoding:
```elixir
iex(1)> XDR.VariableArray.new([1,2,3], XDR.Int) |> XDR.VariableArray.encode_xdr()
{:ok, <<0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3>>}

iex(1)> XDR.VariableArray.new(["The", "little", "prince"], XDR.String) |> XDR.VariableArray.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 3, 84, 104, 101, 0, 0, 0, 0, 6, 108, 105, 116, 116, 108, 101, 0, 0, 0, 0, 0, 6, 112, 114, 105, 110, 99, 101, 0, 0>>
```
Decoding:
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

More examples [here](https://hexdocs.pm/elixir_xdr/variable_length_array.html).

### XDR.Struct - Structure
Represents a collection of fields, possibly of different data types, typically in fixed and sequence numbers.

Encoding:
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

Decoding:
```elixir
iex(1)> struct_spec = XDR.Struct.new([name: XDR.String, size: XDR.Int])
iex(2)> XDR.Struct.decode_xdr(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>, struct_spec)
{:ok, {%XDR.Struct{components: [name: %XDR.String{max_length: 4294967295, string: "The little prince"}, size: %XDR.Int{datum: 298}]}, ""}}

iex(1)> struct_spec = XDR.Struct.new([name: XDR.String, size: XDR.Int])
iex(2)> XDR.Struct.decode_xdr!(<<0, 0, 0, 17, 84, 104, 101, 32, 108, 105, 116, 116, 108, 101, 32, 112, 114, 105, 110, 99, 101, 0, 0, 0, 0, 0, 1, 42>>, struct_spec)
{%XDR.Struct{components: [name: %XDR.String{max_length: 4294967295, string: "The little prince"}, size: %XDR.Int{datum: 298}]}, ""}
```

More examples [here](https://hexdocs.pm/elixir_xdr/structure.html).

### XDR.Union - Discriminated Union
A discriminated union is a type composed of a discriminant followed by a type selected from a set of prearranged types according to the value of the discriminant. The component types are called `arms` of the union and are preceded by the value of the discriminant that implies their encoding or decoding.

The type of discriminant is either `XDR.Int`, `XDR.UInt`, or an `XDR.Enum` type.

The `arms` can be a keyword list or a map and the value of each arm can be either a struct or a module of any XDR type. You can define a default arm using `:default` as a key (The default arm is optional).

Encoding:
```elixir
iex(1)> enum = %XDR.Enum{declarations: [case_1: 1, case_2: 2, case_3: 3], identifier: :case_1}
iex(2)> arms = [case_1: %XDR.Int{datum: 123}, case_2: %XDR.Int{datum: 2}, case_3: XDR.Float, default: XDR.String]
iex(3)> enum |> XDR.Union.new(arms) |> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 123>>}
```

Decoding:
```elixir
iex(1)> enum = %XDR.Enum{declarations: [case_1: 1, case_2: 2, case_3: 3]}
iex(2)> arms = [case_1: %XDR.Int{datum: 123}, case_2: %XDR.Int{datum: 2}, case_3: XDR.Float, default: XDR.String]
iex(3)> union = XDR.Union.new(enum, arms)
iex(4)> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 123>>, union)
{:ok, {{:case_1, %XDR.Int{datum: 123}}, ""}}
```

More examples [here](https://hexdocs.pm/elixir_xdr/discriminated_union.html).

### XDR.Void - Void
Represents a 0-byte quantity.

Encoding:
```elixir
iex(1)> XDR.Void.new(nil) |> XDR.Void.encode_xdr()
{:ok, <<>>}

iex(1)> XDR.Void.new() |> XDR.Void.encode_xdr!()
<<>>
```

Decoding:
```elixir
iex(1)> XDR.Void.decode_xdr(<<>>)
{:ok, {nil, <<>>}}

iex(1)> XDR.Void.decode_xdr!(<<72, 101, 108, 108, 111>>)
{nil, <<72, 101, 108, 108, 111, 0>>}
```

More examples [here](https://hexdocs.pm/elixir_xdr/void.html).

### XDR.Optional - Optional
Represents one kind of union that occurs so frequently that we give it a special syntax of its own for declaring it. An optional-data could be any XDR type of data or `XDR.Void`.

Encoding:
```elixir
iex(1)> XDR.String.new("this is an example.") |> XDR.Optional.new() |> XDR.Optional.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 19, 116, 104, 105, 115, 32, 105, 115, 32, 97, 110, 32, 101, 120, 97, 109, 112, 108, 101, 46, 0>>}

iex(1)> XDR.Optional.new(nil) |> XDR.Optional.encode_xdr!()
<<0, 0, 0, 0>>
```

Decoding:
```elixir
iex(1)> optional_spec = XDR.Optional.new(XDR.String)
iex(2)> XDR.Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 19, 116, 104, 105, 115, 32, 105, 115, 32, 97, 110, 32, 101, 120, 97, 109, 112, 108, 101, 46, 0>>, optional_spec)
{:ok, {%XDR.Optional{type: %XDR.String{max_length: 4294967295, string: "this is an example"}}, ""}}

iex(1)> optional_spec = XDR.Optional.new(XDR.String)
iex(2)> XDR.Optional.decode_xdr!(<<0, 0, 0, 0>>, optional_spec)
{nil, ""}
```

More examples [here](https://hexdocs.pm/elixir_xdr/optional_data.html).

## Development
* Install any Elixir version above 1.7.
* Compile dependencies: `mix deps.get`.
* Run tests: `mix test`.

## Code of conduct
We welcome everyone to contribute. Make sure you have read the [CODE_OF_CONDUCT][coc] before.

## Contributing
For information on how to contribute, please refer to our [CONTRIBUTING][contributing] guide.

## Changelog
Features and bug fixes are listed in the [CHANGELOG][changelog] file.

## License
This library is licensed under an MIT license. See [LICENSE][license] for details.

## Acknowledgements
Made with 💙 by [kommitters Open Source](https://kommit.co)

[license]: https://github.com/kommitters/elixir_xdr/blob/master/LICENSE.md
[coc]: https://github.com/kommitters/elixir_xdr/blob/master/CODE_OF_CONDUCT.md
[changelog]: https://github.com/kommitters/elixir_xdr/blob/master/CHANGELOG.md
[contributing]: https://github.com/kommitters/elixir_xdr/blob/master/CONTRIBUTING.md
[hex]: https://hex.pm/packages/elixir_xdr
