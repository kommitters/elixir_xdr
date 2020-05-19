# Enumeration

 Represents subsets of integers.

## Implementation

To implement an Enumeration type we need to define the declarations as the possible cases to select in these cases will be defined an integer value to each case, for example in boolean case our declarations will be:

```elixir
[false: 0, true: 1]
```
Now, you could decide the key to select


## Usage

### Encoding

```elixir 
iex> XDR.Enum.new([false: 0, true: 1], :false) |> XDR.Enum.encode_xdr()
{:ok, <<0, 0, 0, 0>>}

iex> XDR.Enum.new([false: 0, true: 1], :true) |> XDR.Enum.encode_xdr!()
<<0, 0, 0, 1>>
```

### Decoding

```elixir
iex> XDR.Enum.decode_xdr(<<0, 0, 0, 1>>, %{declarations: [false: 0, true: 1]})
{:ok, {%XDR.Enum{declarations: [false: 0, true: 1], identifier: true}, <<>>}}

iex> XDR.Enum.decode_xdr!(<<0, 0, 0, 1>>, %{declarations: [false: 0, true: 1]})
{%XDR.Enum{declarations: [false: 0, true: 1], identifier: true}, <<>>}
```