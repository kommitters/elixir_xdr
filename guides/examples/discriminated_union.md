# Discriminated Union

 Represents union between an XDR value and the arms contained in the Union

## Implementation

To implement a Union type you must code the arms which contain the value to make the union.

**For Enumeration unions:**
```elixir
arms = [case_1: %XDR.Int{datum: 1}, case_2: %XDR.Int{datum: 2}]
```
**For numeric unions:**
```elixir
arms = %{1 => %XDR.Int{datum: 1}, 2 => %XDR.Int{datum: 2}}
```

## Usage

### Encoding
**For Enumeration unions:**
```elixir 
iex> XDR.Enum.new([case_1: 1, case_2: 2], :case_1)
|> XDR.Union.new(arms)
|> XDR.Union.encode_xdr()

{:ok, <<0, 0, 0, 1, 0, 0, 0, 1>>}
```
**For Numeric unions:**
```elixir 
XDR.Int.new(1) |> XDR.Union.new(arms) |> XDR.Union.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 1>>}

XDR.UInt.new(2) |> XDR.Union.new(arms) |> XDR.Union.encode_xdr!()
<<0, 0, 0, 2, 0, 0, 0, 2>>
```
### Decoding
**For Enumeration unions:**
```elixir 
iex> enum = XDR.Enum.new([case_1: 1, case_2: 2], nil)
iex> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{discriminant: enum, arms: arms})
{:ok, {{:case_1, %XDR.Int{datum: 1}}, <<>>}}
```
**For Numeric unions:**
```elixir 
iex> integer = XDR.Int.new(nil)
iex> XDR.Union.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 1>>, %{discriminant: integer, arms: arms})
{:ok, {{1, %XDR.Int{datum: 1}}, <<>>}}

iex> integer = XDR.UInt.new(nil)
iex> XDR.Union.decode_xdr(<<0, 0, 0, 2, 0, 0, 0, 2>>, %{discriminant: integer, arms: arms})
{{2, %XDR.Int{datum: 2}}, <<>>}
```