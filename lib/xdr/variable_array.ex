defmodule XDR.VariableArray do
  @moduledoc """
  This module manages the `Variable-Length Array` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.Error.VariableArray, as: VariableArrayError
  alias XDR.{UInt, FixedArray}

  defstruct [:elements, :type, :max_length]

  @typedoc """
  `XDR.VariableArray` structure type specification.
  """
  @type t :: %XDR.VariableArray{
          elements: list() | binary(),
          type: module(),
          max_length: integer()
        }

  @doc """
  Create a new `XDR.VariableArray` structure with the `elements`, `type` and `max_length` passed.
  """
  @spec new(elements :: list() | binary(), type :: module(), max_length :: integer()) :: t
  def new(elements, type, max_length \\ 4_294_967_295),
    do: %XDR.VariableArray{elements: elements, type: type, max_length: max_length}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.VariableArray` structure into a XDR format.
  """
  @spec encode_xdr(variable_array :: t) ::
          {:ok, binary()}
          | {:error,
             :not_number
             | :exceed_lower_bound
             | :exceed_upper_bound
             | :not_list
             | :length_over_max}
  def encode_xdr(%{max_length: max_length}) when not is_integer(max_length),
    do: {:error, :not_number}

  def encode_xdr(%{max_length: max_length}) when max_length <= 0,
    do: {:error, :exceed_lower_bound}

  def encode_xdr(%{max_length: max_length}) when max_length > 4_294_967_295,
    do: {:error, :exceed_upper_bound}

  def encode_xdr(%{elements: elements}) when not is_list(elements), do: {:error, :not_list}

  def encode_xdr(%{elements: elements, max_length: max_length})
      when length(elements) > max_length,
      do: {:error, :length_over_max}

  def encode_xdr(%{elements: elements, type: type}) do
    array_length = length(elements)
    encoded_length = array_length |> UInt.new() |> UInt.encode_xdr!()
    encoded_array = FixedArray.new(elements, type, array_length) |> FixedArray.encode_xdr!()
    {:ok, encoded_length <> encoded_array}
  end

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.VariableArray` structure into a XDR format.
  If the `variable_array` is not valid, an exception is raised.
  """
  @spec encode_xdr!(variable_array :: t) :: binary()
  def encode_xdr!(variable_array) do
    case encode_xdr(variable_array) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(VariableArrayError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Variable-Length Array in XDR format to a `XDR.VariableArray` structure.
  """
  @spec decode_xdr(bytes :: binary, struct :: t) ::
          {:ok, {list(), binary()}}
          | {:error,
             :not_number
             | :exceed_lower_bound
             | :exceed_upper_bound
             | :invalid_length
             | :invalid_binary
             | :not_binary}
  def decode_xdr(_bytes, %{max_length: max_length}) when not is_integer(max_length),
    do: {:error, :not_number}

  def decode_xdr(_bytes, %{max_length: max_length}) when max_length <= 0,
    do: {:error, :exceed_lower_bound}

  def decode_xdr(_bytes, %{max_length: max_length}) when max_length > 4_294_967_295,
    do: {:error, :exceed_upper_bound}

  def decode_xdr(bytes, _struct) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(<<xdr_len::big-unsigned-integer-size(32), _::binary>>, %{max_length: max_length})
      when xdr_len > max_length,
      do: {:error, :invalid_length}

  def decode_xdr(<<xdr_len::big-unsigned-integer-size(32), rest::binary>>, _struct)
      when xdr_len * 4 > byte_size(rest),
      do: {:error, :invalid_binary}

  def decode_xdr(bytes, %{type: type}) do
    {array_length, rest} = UInt.decode_xdr!(bytes)

    fixed_array =
      FixedArray.decode_xdr!(rest, %XDR.FixedArray{type: type, length: array_length.datum})

    {:ok, fixed_array}
  end

  @impl XDR.Declaration
  @doc """
  Decode the Variable-Length Array in XDR format to a `XDR.VariableArray` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary, struct :: map()) :: {list, binary}
  def decode_xdr!(bytes, struct) do
    case decode_xdr(bytes, struct) do
      {:ok, result} -> result
      {:error, reason} -> raise(VariableArrayError, reason)
    end
  end
end
