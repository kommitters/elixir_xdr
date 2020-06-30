# XDR.Union - Discriminated Union
A discriminated union is a type composed of a discriminant followed by a type selected from a set of prearranged types according to the value of the discriminant. The component types are called `arms` of the union and are preceded by the value of the discriminant that implies their encoding or decoding.

[Discriminated Union - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.15)

## Implementation

The type of discriminant is either `XDR.Int`, `XDR.UInt`, or an `XDR.Enum` type. 

The `arms` can be a keyword list or a map and the value of each arm can be either a struct or a module of any XDR type. You can define a default arm using `:default` as key (The default arm is optional).

## Usage

### arms definition

**For union with enumeration as discriminant:**
```elixir
iex(1)> arms = [case_1: %XDR.Int{datum: 1}, case_2: %XDR.Int{datum: 2}, case_3: XDR.Int, default: XDR.Float]
```
**For union with integer as discriminant:**
```elixir
iex(1)> arms = %{1 => %XDR.Int{datum: 1}, 2 => %XDR.Int{datum: 2}, 3 => XDR.Int, default: XDR.Float}
```

### Encoding
**For union with enumeration as discriminant:**
```elixir
# encode_xdr

iex(1)> XDR.Enum.new([case_1: 1, case_2: 2], :case_1) |>
...(1)> XDR.Union.new(arms) |>
...(1)> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 1>>}

# encode_xdr!

# Using an XDR module to encode.
# Note you must to pass the value to encode to the function `XDR.Union.new/3`.
iex(1)> XDR.Enum.new([case_1: 1, case_2: 2, case_3: 3], :case_3) |>
...(1)> XDR.Union.new(arms, 100) |>
...(1)> XDR.Union.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 100>>

# Encode a default arm.
iex(1)> XDR.Enum.new([case_1: 1, case_2: 2, case_3: 3, case_10: 10], :case_10) |>
...(1)> XDR.Union.new(arms, 12.3333) |>
...(1)> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 10, 65, 69, 85, 50>>} 
```

**For union with integer as discriminant:**
```elixir 
iex(1)> XDR.Int.new(1) |> XDR.Union.new(arms) |> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 1>>}

iex(1)> XDR.UInt.new(3) |> XDR.Union.new(arms, 100) |> XDR.Union.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 100>> 
```

### Decoding

**For union with enumeration as discriminant:**
```elixir
# decode_xdr

iex(1)> enum = XDR.Enum.new([case_1: 1, case_2: 2], nil)
iex(2)> union_spec = XDR.Union.new(enum, arms) # Define the union specification to decode.
iex(3)> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, union_spec)
{:ok, {{:case_1, %XDR.Int{datum: 1}}, <<>>}}

# decode_xdr!

iex(1)> enum = XDR.Enum.new([case_1: 1, case_2: 2], nil)
iex(2)> union_spec = %{discriminant: enum, arms: arms} # Also you can pass a map as union specification.
iex(3)> XDR.Union.decode_xdr!(<<0, 0, 0, 2, 0, 0, 0, 20>>, union_spec)
{{:case_2, %XDR.Int{datum: 20}}, <<>>}

# Decode a default arm.
iex(1)> enum = XDR.Enum.new([case_1: 1, case_2: 2, case_3: 3, case_10: 10], :case_10)
...(1)> union_spec = XDR.Union.new(enum, arms)
...(1)> XDR.Union.decode_xdr(<<0, 0, 0, 10, 65, 69, 85, 50>>, union_spec)
{:ok, {{:case_10, %XDR.Float{float: 12.33329963684082}}, ""}}
```

**For union with integer as discriminant:**
```elixir
# decode_xdr
iex(1)> integer = XDR.Int.new(nil)
iex(2)> union_spec = XDR.Union.new(integer, arms)
iex(3)> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, union_spec)
{:ok, {{1, %XDR.Int{datum: 1}}, <<>>}}

#decode_xdr!
iex(1)> integer = XDR.UInt.new(nil)
iex(2)> union_spec = XDR.Union.new(integer, arms)
iex(3)> XDR.Union.decode_xdr!(<<0, 0, 0, 2, 0, 0, 0, 7>>, union_spec)
{{2, %XDR.Int{datum: 7}}, <<>>}
```

### Custom Union example

```elixir
defmodule CustomUnion do

  @arms [
    Type_1: Type1,
    Type_2: Type2,
    default: XDR.Void
  ]

  @type t :: XDR.Union.t()

  @spec new(value :: any(), union_type :: atom()) :: t
  def new(value, union_type) do
    union_type |> CustomEnum.new() |> XDR.Union.new(@arms, value)
  end

  @spec spec() :: t
  defp spec(), do: CustomEnum.new(nil) |> Union.new(@arms)

  defdelegate encode_xdr(union), to: XDR.Union
  defdelegate encode_xdr!(union), to: XDR.Union
  defdelegate decode_xdr(bytes, union \\ spec()), to: XDR.Union
  defdelegate decode_xdr!(bytes, union \\ spec()), to: XDR.Union
end
```

```elixir
# Encode
value_depending_on_the_type |> CustomUnion.new(:type_1) |> CustomUnion.encode_xdr()

# Decode
CustomUnion.decode_xdr(<<1, 2, 3, 4, 5, 6, 7, 8>>)
```
