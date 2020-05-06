defmodule XDR.FixedArray do
  @moduledoc """
  this module is in charge of process the Fixed Array types based on the RFC4056 XDR Standard
  """

  alias XDR.Error.FixedArray

  @type array_opts :: [type: nil, length: nil]

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a list into an XDR

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(list :: list, array_opts()) :: {:ok, binary}
  def encode_xdr(_list, type: _type, length: length) when not is_integer(length),
    do: raise(FixedArray, :not_number)

  def encode_xdr(list, type: _type, length: length) when length(list) !== length,
    do: raise(FixedArray, :invalid_length)

  def encode_xdr(list, type: _type, length: _length) when not is_list(list),
    do: raise(FixedArray, :not_list)

  def encode_xdr(list, type: type, length: _length) do
    {:ok,
     Enum.reduce(list, <<>>, fn element, bytes ->
       bytes <> apply(type, :encode_xdr!, [element])
     end)}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a list into an XDR

  returns the resulted XDR
  """
  @spec encode_xdr!(list :: list, array_opts()) :: binary()
  def encode_xdr!(list, type: type, length: length),
    do: encode_xdr(list, type: type, length: length) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a list

  returns an :ok tuple with the resulted list
  """
  @spec decode_xdr(bytes :: binary(), array_opts()) :: {:ok, {list, binary}}
  def decode_xdr(_bytes, type: _type, length: length) when not is_integer(length),
    do: raise(FixedArray, :not_number)

  def decode_xdr(bytes, type: _type, length: _length) when not is_binary(bytes),
    do: raise(FixedArray, :not_binary)

  def decode_xdr(bytes, type: _type, length: _length) when rem(byte_size(bytes), 4) != 0,
    do: raise(FixedArray, :not_valid_binary)

  def decode_xdr(bytes, type: type, length: length) do
    {decoded_array, rest} = decode_elements_from_fixed_array(type, [], bytes, length)

    {:ok, {Enum.reverse(decoded_array), rest}}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a list

  returns the resulted list
  """
  @spec decode_xdr!(bytes :: binary(), array_opts()) :: {list, binary}
  def decode_xdr!(bytes, type: type, length: length),
    do: decode_xdr(bytes, type: type, length: length) |> elem(1)

  @spec decode_elements_from_fixed_array(
          type :: module,
          acc :: list,
          rest :: binary,
          array_length :: integer
        ) :: {list, binary}
  defp decode_elements_from_fixed_array(_type, acc, rest, 0), do: {acc, rest}

  defp decode_elements_from_fixed_array(type, acc, bytes, array_length) do
    {decoded, rest} = apply(type, :decode_xdr!, [bytes])
    decode_elements_from_fixed_array(type, [decoded | acc], rest, array_length - 1)
  end
end
