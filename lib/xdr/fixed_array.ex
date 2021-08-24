defmodule XDR.FixedArray do
  @moduledoc """
  This module manages the `Fixed-Length Array` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.FixedArray, as: FixedArrayError

  defstruct [:elements, :type, :length]

  @typedoc """
  `XDR.FixedArray` structure type specification.
  """
  @type t :: %XDR.FixedArray{elements: list | nil, type: module, length: integer}

  @doc """
  Create a new `XDR.FixedArray` structure with the `elements`, `type` and `length` passed.
  """
  @spec new(elements :: list() | binary(), type :: module(), length :: integer()) :: t()
  def new(elements, type, length),
    do: %XDR.FixedArray{elements: elements, type: type, length: length}

  @doc """
  Encode a `XDR.FixedArray` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%{length: length}) when not is_integer(length), do: {:error, :not_number}

  def encode_xdr(%{elements: elements, length: length}) when length(elements) !== length,
    do: {:error, :invalid_length}

  def encode_xdr(%{elements: elements}) when not is_list(elements), do: {:error, :not_list}
  def encode_xdr(%{type: type}) when not is_atom(type), do: {:error, :invalid_type}

  def encode_xdr(%{elements: elements, type: type}) do
    binary =
      Enum.reduce(elements, <<>>, fn element, bytes -> bytes <> encode_element(element, type) end)

    {:ok, binary}
  end

  @doc """
  Encode a `XDR.FixedArray` structure into a XDR format.
  If the `fixed_array` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(fixed_array) do
    case encode_xdr(fixed_array) do
      {:ok, result} -> result
      {:error, reason} -> raise(FixedArrayError, reason)
    end
  end

  @doc """
  Decode the Fixed-Length Array in XDR format to a `XDR.FixedArray` structure.
  """
  @impl true
  def decode_xdr(_bytes, %{length: length}) when not is_integer(length), do: {:error, :not_number}
  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, _struct) when rem(byte_size(bytes), 4) != 0,
    do: {:error, :not_valid_binary}

  def decode_xdr(_bytes, %{type: type}) when not is_atom(type), do: {:error, :invalid_type}

  def decode_xdr(bytes, %{type: type, length: length}) do
    {:ok, decode_elements_from_fixed_array(type, [], bytes, length)}
  end

  @doc """
  Decode the Fixed-Length Array in XDR format to a `XDR.FixedArray` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, fixed_array) do
    case decode_xdr(bytes, fixed_array) do
      {:ok, result} -> result
      {:error, reason} -> raise(FixedArrayError, reason)
    end
  end

  @spec encode_element(element :: any(), type :: module()) :: binary()
  defp encode_element(element, type), do: element |> type.new() |> type.encode_xdr!()

  @spec decode_elements_from_fixed_array(
          type :: module(),
          acc :: list(),
          rest :: binary(),
          array_length :: integer()
        ) :: {list(), binary()}
  defp decode_elements_from_fixed_array(_type, acc, rest, 0), do: {Enum.reverse(acc), rest}

  defp decode_elements_from_fixed_array(type, acc, bytes, array_length) do
    {decoded, rest} = type.decode_xdr!(bytes)
    decode_elements_from_fixed_array(type, [decoded | acc], rest, array_length - 1)
  end
end
