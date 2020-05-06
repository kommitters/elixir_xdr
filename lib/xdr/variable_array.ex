defmodule XDR.VariableArray do
  @moduledoc """
  this function is in charge of process the variable array types based on the RFC4056 XDR Standard
  """
  @type array_opts :: [type: nil, length: nil]

  alias XDR.Error.VariableArray
  alias XDR.{UInt, FixedArray}

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Variable Array into an XDR

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(array :: list, array_opts) :: {:ok, binary}
  def encode_xdr(_array, type: _type, length: max) when not is_integer(max),
    do: raise(VariableArray, :not_number)

  def encode_xdr(_array, type: _type, length: max) when max <= 0,
    do: raise(VariableArray, :exceed_lower_bound)

  def encode_xdr(_array, type: _type, length: max) when max > 4_294_967_295,
    do: raise(VariableArray, :exceed_upper_bound)

  def encode_xdr(array, type: _type, length: _max) when not is_list(array),
    do: raise(VariableArray, :not_list)

  def encode_xdr(array, type: _type, length: max) when length(array) > max,
    do: raise(VariableArray, :length_over_max)

  def encode_xdr(array, type: type, length: _max) do
    array_length = length(array)
    encoded_length = UInt.encode_xdr!(array_length)
    encoded_array = FixedArray.encode_xdr!(array, type: type, length: array_length)
    {:ok, encoded_length <> encoded_array}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Variable Array into an XDR

  returns the resulted XDR
  """
  @spec encode_xdr!(array :: list, array_opts) :: binary
  def encode_xdr!(array, type: type, length: length),
    do: encode_xdr(array, type: type, length: length) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Variable Array

  returns an :ok tuple with the resulted array
  """
  @spec decode_xdr(bytes :: binary, array_opts) :: {list, binary}
  def decode_xdr(_bytes, type: _type, length: max) when not is_integer(max),
    do: raise(VariableArray, :not_number)

  def decode_xdr(_bytes, type: _type, length: max) when max <= 0,
    do: raise(VariableArray, :exceed_lower_bound)

  def decode_xdr(_bytes, type: _type, length: max) when max > 4_294_967_295,
    do: raise(VariableArray, :exceed_upper_bound)

  def decode_xdr(bytes, type: _type, length: _max) when not is_binary(bytes),
    do: raise(VariableArray, :not_binary)

  def decode_xdr(bytes, type: type, length: _max) do
    {array_length, rest} = UInt.decode_xdr!(bytes)
    {:ok, FixedArray.decode_xdr!(rest, type: type, length: array_length)}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Variable Array

  returns the resulted array
  """
  @spec decode_xdr!(bytes :: binary, array_opts) :: {list, binary}
  def decode_xdr!(bytes, type: type, length: max),
    do: decode_xdr(bytes, type: type, length: max) |> elem(1)
end
