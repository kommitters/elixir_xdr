defmodule XDR.FixedOpaque do
  @moduledoc """
  This module manages the `Fixed-Length Opaque Data` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  defstruct [:opaque, :length]

  alias XDR.Error.FixedOpaque, as: FixedOpaqueError

  @type opaque :: binary() | nil

  @typedoc """
  `XDR.FixedOpaque` structure type specification.
  """
  @type t :: %XDR.FixedOpaque{opaque: opaque(), length: integer}

  @doc """
  Create a new `XDR.FixedOpaque` structure with the `opaque` and `length` passed.
  """
  @spec new(opaque :: opaque(), length :: integer()) :: t()
  def new(opaque, length), do: %XDR.FixedOpaque{opaque: opaque, length: length}

  @doc """
  Encode a `XDR.FixedOpaque` structure into a XDR format.
  """
  @impl true
  def encode_xdr(%{opaque: opaque}) when not is_binary(opaque), do: {:error, :not_binary}
  def encode_xdr(%{length: length}) when not is_integer(length), do: {:error, :not_number}

  def encode_xdr(%{opaque: opaque, length: length}) when length != byte_size(opaque),
    do: {:error, :invalid_length}

  def encode_xdr(%{opaque: opaque, length: length}) when rem(length, 4) === 0, do: {:ok, opaque}

  def encode_xdr(%{opaque: opaque, length: length}) when rem(length, 4) != 0 do
    (opaque <> <<0>>) |> new(length + 1) |> encode_xdr()
  end

  @doc """
  Encode a `XDR.FixedOpaque` structure into a XDR format.
  If the `opaque` is not valid, an exception is raised.
  """
  @impl true
  def encode_xdr!(opaque) do
    case encode_xdr(opaque) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(FixedOpaqueError, reason)
    end
  end

  @doc """
  Decode the Fixed-Length Opaque Data in XDR format to a `XDR.FixedOpaque` structure.
  """
  @impl true
  def decode_xdr(bytes, _opaque) when not is_binary(bytes), do: {:error, :not_binary}

  def decode_xdr(bytes, _opaque) when rem(byte_size(bytes), 4) != 0,
    do: {:error, :not_valid_binary}

  def decode_xdr(_bytes, %{length: length}) when not is_integer(length), do: {:error, :not_number}

  def decode_xdr(bytes, %{length: length}) when length > byte_size(bytes),
    do: {:error, :exceed_length}

  def decode_xdr(bytes, %{length: length}) do
    required_padding = get_required_padding(length)

    <<fixed_opaque::bytes-size(length), _padding::bytes-size(required_padding), rest::binary>> =
      bytes

    decoded_opaque = new(fixed_opaque, length)
    {:ok, {decoded_opaque, rest}}
  end

  @doc """
  Decode the Fixed-Length Array in XDR format to a `XDR.FixedOpaque` structure.
  If the binaries are not valid, an exception is raised.
  """
  @impl true
  def decode_xdr!(bytes, opaque) do
    case decode_xdr(bytes, opaque) do
      {:ok, result} -> result
      {:error, reason} -> raise(FixedOpaqueError, reason)
    end
  end

  @spec get_required_padding(length :: integer()) :: integer()
  defp get_required_padding(length) when rem(length, 4) == 0, do: 0
  defp get_required_padding(length), do: 4 - rem(length, 4)
end
