# Elixir XDR

Process XDR types based on the [RFC4506](https://www.ietf.org/rfc/rfc4506.txt). Extend with ease to other XDR types, no complex

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
The implemente types are implemented basing on the REF4506 standard and you can find the following types completely implemented in elixir XDR:

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

### The following types were not implemented
```
XDR.QuadFloat 					# Section 4.8, not supported for 128-byte size.
XDR.Const 							# Section 4.17, can be replaced with elixir constants.
XDR.Typedef 						# Section 4.18, may be implemented with elixir modules. More info bellow in this guude.
```

## Behaviour is the key
All the XDR types are implemented under the specifications of a `behavior` which declares 4 functions, all the XDR implementations must satisfy the [Behaviour](https://github.com/kommitters/xdr/blob/develop/lib/xdr/declaration.ex), this is important because these functions will be used in all the new implementations of XDR types.

## How to implement basic XDR types?
All the functions have implemented the [Behaviour](https://github.com/kommitters/xdr/blob/develop/lib/xdr/declaration.ex) functions, these functions will make all the work for us, for example, if you want to encode a basic type you only need to create a new XDR structure with the help of the `new/1` function and sent it to the function encode_xdr/2 as you see in the following example.

### XDR.Int
```elixir
iex> XDR.Int.new(1234) |> XDR.Int.encode_xdr()
{:ok, <<0, 0, 4, 210>>}
```
To decode this binary value you can use the `decode_xdr/2` function, in these basic types you only need the fist parameter to send the data.

```elixir
iex> XDR.Int.decode_xdr(<<0, 0, 4, 210>>)
{:ok, {%XDR.Int{datum: 1234}, <<>>}}
```

If you don't like or need the tuples, you can use the encode_xdr!/1 and decode_xdr!/2 functions to get only the decoded value.
```elixir
iex> XDR.Int.decode_xdr!(<<0, 0, 4, 210>>)
{%XDR.Int{datum: 1234}, <<>>}
```

If you pay attention to the return you can see that is a tuple, that is because when we have a bunch of bytes that exceeds the byte size of the type (4 in this case) the second item will contain the rest of the binary, see the following example to solve your doubts.
```elixir
iex> XDR.Int.decode_xdr!(<<0, 0, 4, 210, 0, 0, 0, 0>>)
{%XDR.Int{datum: 1234}, <<0, 0, 0, 0>>}
```
The rest binaries will be very helpful when we start to use more complex types! If you need examples for the other basic types you can see the documentation, it's so intuitive with this type in mind.

## How to implement complex XDR types?
Remember these types also are XDR implementations and satisfy the XDR.Declaration `@behaviour`

### XDR.Enum
This type is simple, consists of things the declarations and the identifier, the declarations represent the possible values of the enum representation and the identifier represent the value to select from the declarations, Let's put on the context, in an Enumtype the declarations are a keyword list which contains the keys (identifiers).

Let's put on the context, in an Enum Type the declarations are a keyword list that contains the keys which can be selected, this selection can be performed with the help of the identifier which is received by parameter, but what we really need is the value associated with the key... this value will be encoded.

### What I'm talking about?
Let's see the implementation for the [XDR.Bool](https://github.com/kommitters/xdr/blob/develop/lib/xdr/bool.ex) type which is basically an Enum implementation, and sees how can we use it

First, we need to define what item needs from the keyword, `true` in this case and we can encode it
```elixir
iex> XDR.Bool.new(true) |> XDR.Bool.encode_xdr()
{:ok, <<0, 0, 0, 0>>}
```
To decode this binary you can use the following:

```elixir
iex> XDR.Bool.decode_xdr(<0, 0, 0, 1>>)
{:ok, {%XDR.Bool{declarations: [false: 0, true: 1], identifier: true}, ""}
```
The [XDR.Bool](https://github.com/kommitters/xdr/blob/develop/lib/xdr/bool.ex) module is the perfect example to show an Enum implementation, as you see first we create a keyword which will be used as declarations, the declarations in an Enum type are always statically defined because in an enum implementation type you must have these declarations to use them.

Now we can continue with the decoding, something very important that we must have in mind when you try to decode any structure is to send the correct parameters, the decode_xdr / 2 function always receives the set of binaries as the first parameter and a structure containing the information necessary to decode those binaries in the correct structure, that is very important because you can add this structure on the code and you won't worry about it in the future, in this case, that structure represents a boolean which contains the declarations, these will be used to return the declaration to which the binaries belong.

## Implements a FixedOpaque type
This type is very simple, let's think of a string that must always match the same length regardless of whether it receives fewer characters than necessary. In these cases, we can use a [FixedOpaque implementation](https://gist.github.com/FranciscoMolina02/b480116b9972b8d40f947420ecabc7dc), for example.

We have the following binary `<<1,2,3,4,5>>` but we need this with a valid length, for this cases we are going to us the FixedOpaque

```elixir
iex> IncrementBinarySize.new(<<1,2,3,4,5>>) |> IncrementBinarySize.encode_xdr()
{:ok, <<1, 2, 3, 4, 5, 0, 0, 0>>}
```

## Implements a Struct type
Let's see the next example, we can create a new [Struct Implementation](https://gist.github.com/FranciscoMolina02/3051da1851c793d3813c8a2ab3ca9231)

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

## Implements a Union type
The Union type is more complex because you need to have defined the type with which the union will be made, this can be Enum, Int, or UInt.
First, we are going to implement the case using an Enum, we need an Enum implementation already defined as XDR.Bool.

In this case, we will implement an XDR.Enum module called [SCPStatementType](https://gist.github.com/FranciscoMolina02/61194bfe030a43bdefb7e2826f835155) this module can be any Enum module.

After that we can create the Union Implementation we will name it [UnionSCPStatementType](https://gist.github.com/FranciscoMolina02/a68d75c3d27478fdbe8f6b7d1d5bf532)

That's all! Now we can use it as a union!

### Using UnionSCPStatementType module
```elixir
iex(1)> UnionSCPStatementType.new(:SCP_ST_NOMINATE) |> UnionSCPStatementType.encode_xdr()
{:ok, <<0, 0, 0, 3, 64, 93, 112, 164>>}

iex(3)> UnionSCPStatementType.decode_xdr(<<0, 0, 0, 3, 64, 93, 112, 164>>)
{:ok, {{:SCP_ST_NOMINATE, %XDR.Float{float: 3.4600000381469727}}, ""}}
```

### Using UnionInt or UnionUint module

Now we are going to implement a Union type but using and UInt type instead of Enum we will call it [UnionNumber](https://gist.github.com/FranciscoMolina02/f4bd351ff69f8d77ee4edb3b20db5042)

```elixir
iex(1)> UnionNumber.new(2) |> UnionNumber.encode_xdr()
{:ok, <<0, 0, 0, 2, 0, 0, 0, 0>>}

iex(2)> UnionNumber.decode_xdr(<<0, 0, 0, 2, 0, 0, 0, 0>>)
{:ok,
 {{2, %XDR.Bool{declarations: [false: 0, true: 1], identifier: false}}, ""}}
```

## Implements an Optional type

We will implement an Optional type and we will call it [Optional String](https://gist.github.com/FranciscoMolina02/4ede1d0d2a12cdc84d1a30ff8d3e36cd)

```
iex(1)> OptionalString.new(XDR.String.new("Hello")) |> OptionalString.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 5, 72, 101, 108, 108, 111, 0, 0, 0>>}

iex(2)> OptionalString.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 5, 72, 101, 108, 108, 111, 0, 0, 0>>)
{:ok,
 {%XDR.Optional{type: %XDR.String{max_length: 4294967295, string: "Hello"}}, ""}}

iex(3)> OptionalString.new(nil) |> OptionalString.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex(4)> OptionalString.decode_xdr(<<0, 0, 0, 0>>)
{:ok, {nil, ""}}
```

## Contributing and Development

See [CONTRIBUTING.md](https://github.com/kommitters/elixir_xdr/blob/master/CONTRIBUTING.md)
for guidance on how to develop for this library.

Bug reports and pull requests are welcome on GitHub at https://github.com/kommitters/elixir_xdr.

Everyone is welcome to participate in the project.

## License

See [LICENSE](https://github.com/kommitters/elixir_xdr/blob/master/LICENSE) for details.
