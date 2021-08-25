# XDR.Enum - Enumeration
Represents subsets of integers.
The Enumeration's declarations is a keyword list of integers (E.g. `[false: 0, true: 1]`).

 [Enumeration - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.3)

## Implementation
To implement an Enumeration type, we need to define the declarations as a keyword list that contains the possible values to select in each key.

## Usage

### Encoding

```elixir 
iex(1)> XDR.Enum.new([false: 0, true: 1], :false) |> XDR.Enum.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex(1)> XDR.Enum.new([false: 0, true: 1], :true) |> XDR.Enum.encode_xdr!()
<<0, 0, 0, 1>>
```

### Decoding

```elixir
iex(1)> enum_spec = XDR.Enum.new([false: 0, true: 1], nil)
iex(2)> XDR.Enum.decode_xdr(<<0, 0, 0, 1>>, enum_spec)
{:ok, {%XDR.Enum{declarations: [false: 0, true: 1], identifier: true}, <<>>}}

iex(1)> XDR.Enum.decode_xdr!(<<0, 0, 0, 0>>, %{declarations: [false: 0, true: 1]})
{%XDR.Enum{declarations: [false: 0, true: 1], identifier: false}, <<>>}
```

### Custom Enumeration example

```elixir
  defmodule CustomEnum do

    @declarations [type_1: 1, type_2: 2, type_3: 3]

    @type t :: XDR.Enum.t()

    @spec new(identifier :: atom()) :: t
    def new(identifier \\ nil), do: XDR.Enum.new(@declarations, identifier)

    defdelegate encode_xdr(custom_enum), to: XDR.Enum
    defdelegate encode_xdr!(custom_enum), to: XDR.Enum
    defdelegate decode_xdr(bytes, custom_enum \\ new()), to: XDR.Enum
    defdelegate decode_xdr!(bytes, custom_enum \\ new()), to: XDR.Enum
  end
```

```elixir
# Encode
CustomEnum.new(:type_2) |> CustomEnum.encode_xdr()

# Decode
CustomEnum.decode_xdr!(<<0, 0, 0, 2>>)
```
