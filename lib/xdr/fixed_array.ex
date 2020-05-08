defmodule XDR.FixedArray do
  @moduledoc """
  this module is in charge of process the Fixed Array types based on the RFC4506 XDR Standard
  """

  @behaviour XDR.Declaration

  defstruct elements: nil, type: nil, length: nil

  @typedoc """
  Every FixedArray structure has the list of elements to encode,the type of these elements and the length of the list
  """
  @type t :: %XDR.FixedArray{elements: list | binary, type: module, length: integer}

  alias XDR.Error.FixedArray

  @doc """
  this function provides an easy way to create an XDR.FixedArray type

  returns a XDR.FixedArray struct with the value received as parameter
  """
  @spec new(elements :: list | binary, type :: module, length :: integer) :: t()
  def new(elements, type, length),
    do: %XDR.FixedArray{elements: elements, type: type, length: length}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a list into an XDR, it receives an XDR.FixedArray structure which contains the
  data needed to encode the fixed array

  returns an :ok tuple with the resulted XDR
  """
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.FixedArray{length: length}) when not is_integer(length),
    do: raise(FixedArray, :not_number)

  def encode_xdr(%XDR.FixedArray{elements: elements, length: length})
      when length(elements) !== length,
      do: raise(FixedArray, :invalid_length)

  def encode_xdr(%XDR.FixedArray{elements: elements}) when not is_list(elements),
    do: raise(FixedArray, :not_list)

  def encode_xdr(%XDR.FixedArray{elements: elements, type: type}) do
    {:ok,
     Enum.reduce(elements, <<>>, fn element, bytes ->
       bytes <> apply(type, :encode_xdr!, [apply(type, :new, [element])])
     end)}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a list into an XDR, it receives an XDR.FixedArray structure which contains the
  data needed to encode the fixed array

  returns the resulted XDR
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(fixed_array), do: encode_xdr(fixed_array) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a list, it receives an XDR.FixedArray structure which contains the data
  to decode the binary

  returns an :ok tuple with the resulted list
  """
  @spec decode_xdr(t()) :: {:ok, {list, binary}}
  def decode_xdr(%XDR.FixedArray{length: length}) when not is_integer(length),
    do: raise(FixedArray, :not_number)

  def decode_xdr(%XDR.FixedArray{elements: elements}) when not is_binary(elements),
    do: raise(FixedArray, :not_binary)

  def decode_xdr(%XDR.FixedArray{elements: elements}) when rem(byte_size(elements), 4) != 0,
    do: raise(FixedArray, :not_valid_binary)

  def decode_xdr(%XDR.FixedArray{elements: elements, type: type, length: length}) do
    {decoded_array, rest} = decode_elements_from_fixed_array(type, [], elements, length)

    {:ok, {Enum.reverse(decoded_array), rest}}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a list, it receives an XDR.FixedArray structure which contains the data
  to decode the binary

  returns the resulted list
  """
  @spec decode_xdr!(t()) :: {list, binary}
  def decode_xdr!(fixed_array), do: decode_xdr(fixed_array) |> elem(1)

  @spec decode_elements_from_fixed_array(
          type :: module,
          acc :: list,
          rest :: binary,
          array_length :: integer
        ) :: {list, binary}
  defp decode_elements_from_fixed_array(_type, acc, rest, 0), do: {acc, rest}

  defp decode_elements_from_fixed_array(type, acc, bytes, array_length) do
    {decoded, rest} = apply(type, :decode_xdr!, [apply(type, :new, [bytes])])
    decode_elements_from_fixed_array(type, [decoded | acc], rest, array_length - 1)
  end
end
