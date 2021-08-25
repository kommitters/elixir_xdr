defmodule XDR.VariableOpaque do
  @moduledoc """
  This module manages the `Variable-Length Opaque Data` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  alias XDR.{FixedOpaque, UInt}
  alias XDR.Error.VariableOpaque, as: VariableOpaqueError

  defstruct [:opaque, :max_size]

  @type opaque :: binary() | nil

  @typedoc """
  `XDR.VariableOpaque` structure type specification.
  """
  @type t :: %XDR.VariableOpaque{opaque: opaque(), max_size: integer()}

  @doc """
  Create a new `XDR.VariableOpaque` structure with the `opaque` and `max_size` passed.
  """
  @spec new(opaque :: opaque(), max_size :: integer()) :: t()
  def new(opaque, max_size \\ 4_294_967_295)
  def new(opaque, max_size), do: %XDR.VariableOpaque{opaque: opaque, max_size: max_size}

  @doc """
  Encode a `XDR.VariableOpaque` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%{opaque: opaque}) when not is_binary(opaque),
    do: {:error, :not_binary}

  def encode_xdr(%{max_size: max_size}) when not is_integer(max_size),
    do: {:error, :not_number}

  def encode_xdr(%{max_size: max_size}) when max_size <= 0,
    do: {:error, :exceed_lower_bound}

  def encode_xdr(%{max_size: max_size}) when max_size > 4_294_967_295,
    do: {:error, :exceed_upper_bound}

  def encode_xdr(%{opaque: opaque, max_size: max_size})
      when byte_size(opaque) > max_size,
      do: {:error, :invalid_length}

  def encode_xdr(%{opaque: opaque}) do
    length = byte_size(opaque)
    opaque_length = length |> UInt.new() |> UInt.encode_xdr!()
    fixed_opaque = FixedOpaque.new(opaque, length) |> FixedOpaque.encode_xdr!()
    {:ok, opaque_length <> fixed_opaque}
  end

  @doc """
  Encode a `XDR.VariableOpaque` structure into a XDR format.
  If the `opaque` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(opaque) do
    case encode_xdr(opaque) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(VariableOpaqueError, reason)
    end
  end

  @doc """
  Decode the Variable-Length Opaque Data in XDR format to a `XDR.VariableOpaque` structure.
  """
  @impl true
  def decode_xdr(bytes, opaque \\ %{max_size: 4_294_967_295})

  def decode_xdr(bytes, _opaque) when not is_binary(bytes),
    do: {:error, :not_binary}

  def decode_xdr(_bytes, %{max_size: max_size}) when not is_integer(max_size),
    do: {:error, :not_number}

  def decode_xdr(_bytes, %{max_size: max_size}) when max_size <= 0,
    do: {:error, :exceed_lower_bound}

  def decode_xdr(_bytes, %{max_size: max_size}) when max_size > 4_294_967_295,
    do: {:error, :exceed_upper_bound}

  def decode_xdr(bytes, %{max_size: max_size}) do
    {uint, rest} = UInt.decode_xdr!(bytes)
    uint.datum |> get_decoded_value(rest, max_size)
  end

  @doc """
  Decode the Variable-Length Opaque Data in XDR format to a `XDR.VariableOpaque` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, opaque \\ %{max_size: 4_294_967_295})

  def decode_xdr!(bytes, opaque) do
    case decode_xdr(bytes, opaque) do
      {:ok, result} -> result
      {:error, reason} -> raise(VariableOpaqueError, reason)
    end
  end

  @spec get_decoded_value(length :: integer(), rest :: binary(), max :: integer()) ::
          {:ok, {t(), binary()}}
  defp get_decoded_value(length, _rest, max) when length > max, do: {:error, :length_over_max}

  defp get_decoded_value(length, rest, _max) when length > byte_size(rest),
    do: {:error, :length_over_rest}

  defp get_decoded_value(length, rest, max) do
    {fixed_opaque, rest} = FixedOpaque.decode_xdr!(rest, %XDR.FixedOpaque{length: length})
    decoded_variable_array = fixed_opaque.opaque |> new(max)
    {:ok, {decoded_variable_array, rest}}
  end
end
