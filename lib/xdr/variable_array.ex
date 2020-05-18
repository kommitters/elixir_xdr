defmodule XDR.VariableArray do
  @behaviour XDR.Declaration
  @moduledoc """
  this module is in charge of process the variable array types based on the RFC4506 XDR Standard
  """

  defstruct elements: nil, type: nil, max_length: nil

  @typedoc """
  Every VariableArray structure has the list of elements to encode, the type of these elements and the max_length of the list
  """
  @type t :: %XDR.VariableArray{elements: list | binary, type: module, max_length: integer}

  alias XDR.Error.VariableArray
  alias XDR.{UInt, FixedArray}

  @doc """
  this function provides an easy way to create an XDR.VariableArray type, it receives an XDR.VariableArray structure which contains the
  data needed to encode the Variable Array

  returns a XDR.VariableArray struct with the value received as parameter
  """
  @spec new(elements :: list | binary, type :: module, max_length :: integer) :: t()
  def new(elements, type, max_length),
    do: %XDR.VariableArray{elements: elements, type: type, max_length: max_length}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Variable Array into an XDR, it receives an XDR.VariableArray structure which
  contains the data needed to encode the variable array

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(map()) :: {:ok, binary}
  def encode_xdr(%{max_length: max_length}) when not is_integer(max_length),
    do: raise(VariableArray, :not_number)

  def encode_xdr(%{max_length: max_length}) when max_length <= 0,
    do: raise(VariableArray, :exceed_lower_bound)

  def encode_xdr(%{max_length: max_length}) when max_length > 4_294_967_295,
    do: raise(VariableArray, :exceed_upper_bound)

  def encode_xdr(%{elements: elements}) when not is_list(elements),
    do: raise(VariableArray, :not_list)

  def encode_xdr(%{elements: elements, max_length: max_length})
      when length(elements) > max_length,
      do: raise(VariableArray, :length_over_max)

  def encode_xdr(%{elements: elements, type: type}) do
    array_length = length(elements)

    encoded_length =
      UInt.new(array_length)
      |> UInt.encode_xdr!()

    encoded_array =
      FixedArray.new(elements, type, array_length)
      |> FixedArray.encode_xdr!()

    {:ok, encoded_length <> encoded_array}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Variable Array into an XDR, it receives an XDR.VariableArray structure which
  contains the data needed to encode the variable array

  returns the resulted XDR
  """
  @spec encode_xdr!(map()) :: binary
  def encode_xdr!(variable_array), do: encode_xdr(variable_array) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Variable Array, it receives an XDR.VariableArray structure which
  contains the data needed to decode the binary

  returns an :ok tuple with the resulted array
  """
  @spec decode_xdr(bytes :: binary, struct :: map()) :: {:ok, {list, binary}}
  def decode_xdr(_bytes, %{max_length: max_length})
      when not is_integer(max_length),
      do: raise(VariableArray, :not_number)

  def decode_xdr(_bytes, %{max_length: max_length}) when max_length <= 0,
    do: raise(VariableArray, :exceed_lower_bound)

  def decode_xdr(_bytes, %{max_length: max_length})
      when max_length > 4_294_967_295,
      do: raise(VariableArray, :exceed_upper_bound)

  def decode_xdr(<<xdr_len::big-unsigned-integer-size(32), _::binary>>, %{
        max_length: max_length
      })
      when xdr_len > max_length,
      do: raise(VariableArray, :invalid_length)

  def decode_xdr(<<xdr_len::big-unsigned-integer-size(32), rest::binary>>, _struct)
      when xdr_len * 4 > byte_size(rest),
      do: raise(VariableArray, :invalid_binary)

  def decode_xdr(bytes, _struct) when not is_binary(bytes),
    do: raise(VariableArray, :not_binary)

  def decode_xdr(bytes, %{type: type}) do
    {array_length, rest} = UInt.decode_xdr!(bytes)

    fixed_array =
      rest
      |> FixedArray.decode_xdr!(%XDR.FixedArray{type: type, length: array_length.datum})

    {:ok, fixed_array}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Variable Array, it receives an XDR.VariableArray structure which
  contains the data needed to decode the binary

  returns the resulted array
  """
  @spec decode_xdr!(bytes :: binary, struct :: map()) :: {list, binary}
  def decode_xdr!(bytes, struct), do: decode_xdr(bytes, struct) |> elem(1)
end
