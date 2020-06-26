# Discriminated Union

Represents an xdr discriminated union.

## Implementation

The type of discriminant is either `XDR.Int`, `XDR.UInt`, or an `XDR.Enum` type. 

The `arms` can be a keyword list or a map and the value of each arm can be either a struct or a module of any XDR type.

**For Enumeration unions:**
```elixir
arms = [case_1: %XDR.Int{datum: 1}, case_2: %XDR.Int{datum: 2}, case_3: XDR.Int]
```

**For numeric unions:**
```elixir
arms = %{1 => %XDR.Int{datum: 1}, 2 => %XDR.Int{datum: 2}, 3 => XDR.Int}
```

### Custom Union

You can define your own custom union:

```elixir
defmodule CustomUnion do

  @arms [
    Type_1: Type1,
    Type_2: Type2,
    default: Void
  ]

  @type t :: Union.t()

  @spec new(union :: any(), union_code :: atom()) :: t
  def new(union, union_code) do
    union_code |> CustomEnum.new() |> Union.new(@arms, union)
  end

  @spec spec() :: t
  defp spec(), do: CustomEnum.new(nil) |> Union.new(@arms)

  defdelegate encode_xdr(union), to: Union
  defdelegate encode_xdr!(union), to: Union
  defdelegate decode_xdr(bytes, union \\ spec()), to: Union
  defdelegate decode_xdr!(bytes, union \\ spec()), to: Union
end
```

## Usage

### Encoding
**For Enumeration unions:**
```elixir 
iex(1)> XDR.Enum.new([case_1: 1, case_2: 2], :case_1)
|> XDR.Union.new(arms)
|> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 1>>}

# Using an XDR module to encode.
# Note you must to pass the value to encode to the function `XDR.Union.new/3`.
iex(1)> XDR.Enum.new([case_1: 1, case_2: 2, case_3: 3], :case_3)
|> XDR.Union.new(arms, 100)
|> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 3, 0, 0, 0, 100>>}
```

**For Numeric unions:**
```elixir 
iex(1)> XDR.Int.new(1) |> XDR.Union.new(arms) |> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 1>>}

iex(1)> XDR.UInt.new(3) |> XDR.Union.new(arms, 100) |> XDR.Union.encode_xdr!()
<<0, 0, 0, 3, 0, 0, 0, 100>> 
```

### Decoding

**For Enumeration unions:**
```elixir 
iex(1)> enum = XDR.Enum.new([case_1: 1, case_2: 2], nil)
iex(2)> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{discriminant: enum, arms: arms})
{:ok, {{:case_1, %XDR.Int{datum: 1}}, <<>>}}
```

**For Numeric unions:**
```elixir 
iex(1)> integer = XDR.Int.new(nil)
iex(2)> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{discriminant: integer, arms: arms})
{:ok, {{1, %XDR.Int{datum: 1}}, <<>>}}

iex(1)> integer = XDR.UInt.new(nil)
iex(2)> XDR.Union.decode_xdr(<<0, 0, 0, 2, 0, 0, 0, 2>>, %{discriminant: integer, arms: arms})
{{2, %XDR.Int{datum: 2}}, <<>>}
```
