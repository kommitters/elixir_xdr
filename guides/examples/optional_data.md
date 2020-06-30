# XDR.Optional - Optional-Data
Represents one kind of union that occurs so frequently that we give it a special syntax of its own for declaring it. An optional-data could be any XDR type of data or `XDR.Void`.

[Optional-Data - RFC 4506](https://tools.ietf.org/html/rfc4506#section-4.19)

## Usage

### Encoding
```elixir 
iex(1)> XDR.String.new("this is an example.") |> XDR.Optional.new() |> XDR.Optional.encode_xdr()
{:ok, <<0, 0, 0, 1, 0, 0, 0, 19, 116, 104, 105, 115, 32, 105, 115, 32, 97, 110, 32, 101, 120, 97, 109, 112, 108, 101, 46, 0>>}

iex(1)> XDR.Optional.new(nil) |> XDR.Optional.encode_xdr!()
<<0, 0, 0, 0>>
```
### Decoding
```elixir 
iex(1)> optional_spec = XDR.Optional.new(XDR.String)
iex(2)> XDR.Optional.decode_xdr(<<0, 0, 0, 1, 0, 0, 0, 19, 116, 104, 105, 115, 32, 105, 115, 32, 97, 110, 32, 101, 120, 97, 109, 112, 108, 101, 46, 0>>, optional_spec)
{:ok, {%XDR.Optional{type: %XDR.String{max_length: 4294967295, string: "this is an example"}}, ""}} 

iex(1)> optional_spec = XDR.Optional.new(XDR.String)
iex(2)> XDR.Optional.decode_xdr!(<<0, 0, 0, 0>>, optional_spec)
{nil, ""}
```

### Custom Optional-Data example

```elixir
  defmodule CustomOptional do

    @type t :: XDR.Optional.t()

    @spec new(number :: XDR.Int.t()) :: t
    def new(number \\ nil), do: XDR.Optional.new(time_bounds)

    @spec spec() :: t
    defp spec(), do: XDR.Int |> new()

    defdelegate encode_xdr(optional_number), to: XDR.Optional
    defdelegate encode_xdr!(optional_number), to: XDR.Optional
    defdelegate decode_xdr(bytes, optional_number \\ spec()), to: XDR.Optional
    defdelegate decode_xdr!(bytes, optional_number \\ spec()), to: XDR.Optional
  end
```

```elixir
# Encode
XDR.Int.new(123) |> CustomOptional.new() |> CustomOptional.encode_xdr()

# Decode
CustomOptional.decode_xdr!(<<0, 0, 0, 0>>)
```
