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

## How to implement a XDR type?
**Behavior is the key**. When implementing a new XDR type follow this [Behavior's Declaration](https://github.com/kommitters/elixir_xdr/blob/develop/lib/xdr/declaration.ex).

## Decoding output
Encoded binaries may overflow the byte(s) size. That's why the returning value for decoding functions is set to be a tuple. Second element holds the remaining binary after decoding. **This applies to all XDR types**.
```elixir
iex> XDR.Int.decode_xdr!(<<0, 0, 4, 210, 5>>)
{%XDR.Int{datum: 1234}, <<5>>}
```

## Usage examples
### XDR.Int
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

### XDR.Bool
As mentioned before all the XDR types follow the same [Behavior's Declaration](https://github.com/kommitters/elixir_xdr/blob/develop/lib/xdr/declaration.ex)
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

### XDR.Enum
Enums are keywords lists containing a set of **declarations (statically defined)** and a **indentifier** with the key of the selected declaration.

The [XDR.Bool](https://github.com/kommitters/elixir_xdr/blob/develop/lib/xdr/bool.ex) is a clear example of an Enum implementation.
```elixir
iex> XDR.Bool.decode_xdr!<<0, 0, 0, 1>>)
{%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
```

### XDR.FixedOpaque
FixedOpaque is used for fixed-length uninterpreted data that needs to be passed among machines, in other words, let's think on a string that must match a fixed length.

```elixir
iex> ComplementBinarySize.new(<<1,2,3,4,5>>) |> ComplementBinarySize.encode_xdr()
{:ok, <<1, 2, 3, 4, 5, 0, 0, 0>>}
```
An example is available here: [FixedOpaque Type](https://github.com/kommitters/elixir_xdr/wiki/FixedOpaque-example).

### XDR.String
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

### XDR.Struct
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


### XDR.Union
A union is a type composed of a discriminant **(Statement)** followed by a type selected from a set of prearranged types **(UnionStatement)**. The type of discriminant is either "Int", "Unsigned Int", or an Enumerated type, such as "Bool". The **(UnionStatement)** types are called "arms" of the union and are preceded by the value of the discriminant that implies their encoding.

```elixir
iex(1)> XDR.UnionStatement.new(:ST_NOMINATE) |> XDR.UnionStatement.encode_xdr()
{:ok, <<0, 0, 0, 3, 64, 93, 112, 164>>}

iex(3)> XDR.UnionStatement.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)
{:ok, {{:ST_NOMINATE, %XDR.Float{float: 3.4600000381469727}}, ""}}
```

An example is available here: [Union Example](https://github.com/kommitters/elixir_xdr/wiki/Union-example)

### XDR.Optional
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
