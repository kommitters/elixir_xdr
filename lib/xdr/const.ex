defmodule XDR.Const do
@behaviour XDR.Declaration

defstruct value: nil, name: nil

@type t :: %XDR.Const{value: any, name: XDR.String.t()}

def new(value, name), do: %XDR.Const{value: value, name: name}

def encode_xdr(%{name: name}) when not is_bitstring(name), do: {:raise, :not_valid_name}
def encode_xdr(%{value: value, name: name}) do
  binary_name =
    XDR.String.new(name)
    |> XDR.String.encode_xdr!()

  value_module = value.__struct__
  binary_value = value_module.encode_xdr!(value)

  {:ok, binary_name <> binary_value}
end

def encode_xdr!(const), do: encode_xdr(const) |> elem(1)

def decode_xdr(%{value: value}) when not is_binary(value), do: {:raise, :not_binary}
def decode_xdr(%{value: value, struct: struct}) do
  {name, rest_value} =
    XDR.String.new(value)
    |> XDR.String.decode_xdr!()

    const_module = struct.value

  {value, rest} =
    const_module.new(rest_value)
    |> const_module.decode_xdr!()

  {:ok, {%{name: name, value: value}, rest}}
end

def decode_xdr!(const), do: decode_xdr(const) |> elem(1)
end
