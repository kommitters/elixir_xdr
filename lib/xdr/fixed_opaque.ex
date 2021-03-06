defmodule XDR.FixedOpaque do
  @moduledoc """
  This module manages the `Fixed-Length Opaque Data` type based on the RFC4506 XDR Standard.
  """

  @behaviour XDR.Declaration

  defstruct [:opaque, :length]

  alias XDR.Error.FixedOpaque, as: FixedOpaqueError

  @typedoc """
  `XDR.FixedOpaque` structure type specification.
  """
  @type t :: %XDR.FixedOpaque{opaque: binary | nil, length: integer}

  @doc """
  Create a new `XDR.FixedOpaque` structure with the `opaque` and `length` passed.
  """
  @spec new(opaque :: binary, length :: integer) :: t
  def new(opaque, length), do: %XDR.FixedOpaque{opaque: opaque, length: length}

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.FixedOpaque` structure into a XDR format.
  """
  @spec encode_xdr(opaque :: t | map()) ::
          {:ok, binary} | {:error, :not_binary | :not_number | :invalid_length}
  def encode_xdr(%{opaque: opaque}) when not is_binary(opaque), do: {:error, :not_binary}
  def encode_xdr(%{length: length}) when not is_integer(length), do: {:error, :not_number}

  def encode_xdr(%{opaque: opaque, length: length}) when length != byte_size(opaque),
    do: {:error, :invalid_length}

  def encode_xdr(%{opaque: opaque, length: length}) when rem(length, 4) === 0, do: {:ok, opaque}

  def encode_xdr(%{opaque: opaque, length: length}) when rem(length, 4) != 0 do
    (opaque <> <<0>>) |> new(length + 1) |> encode_xdr()
  end

  @impl XDR.Declaration
  @doc """
  Encode a `XDR.FixedOpaque` structure into a XDR format.
  If the `opaque` is not valid, an exception is raised.
  """
  @spec encode_xdr!(opaque :: t | map()) :: binary()
  def encode_xdr!(opaque) do
    case encode_xdr(opaque) do
      {:ok, binary} -> binary
      {:error, reason} -> raise(FixedOpaqueError, reason)
    end
  end

  @impl XDR.Declaration
  @doc """
  Decode the Fixed-Length Opaque Data in XDR format to a `XDR.FixedOpaque` structure.
  """
  @spec decode_xdr(bytes :: binary(), opaque :: t | map()) ::
          {:ok, {t, binary()}}
          | {:error, :not_binary | :not_valid_binary | :not_number | :exceed_length}
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

  @impl XDR.Declaration
  @doc """
  Decode the Fixed-Length Array in XDR format to a `XDR.FixedOpaque` structure.
  If the binaries are not valid, an exception is raised.
  """
  @spec decode_xdr!(bytes :: binary(), opaque :: t | map()) :: {t, binary()}
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
