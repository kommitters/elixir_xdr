defmodule XDR.FixedOpaque do
  @moduledoc """
  This module is in charge of process the Fixed Length Opaque based on the RFC4056 XDR Standard
  """

  alias XDR.Error.FixedOpaque, as: FixedOpaqueErr

  @behaviour XDR.Declaration

  @doc """
  this function is in charge of encode a Fixed Length Opaque into an XDR

  returns an ok tuple with the resulted XDR
  """
  @impl XDR.Declaration
  @spec encode_xdr(binary, integer) :: {:ok, binary}
  def encode_xdr(xdr, _length) when not is_binary(xdr), do: raise(FixedOpaqueErr, :not_binary)
  def encode_xdr(_xdr, length) when not is_integer(length), do: raise(FixedOpaqueErr, :not_number)

  def encode_xdr(xdr, length) when length != byte_size(xdr),
    do: raise(FixedOpaqueErr, :invalid_length)

  def encode_xdr(xdr, length) when rem(length, 4) === 0, do: {:ok, xdr}
  def encode_xdr(xdr, length) when rem(length, 4) != 0, do: encode_xdr(xdr <> <<0>>, length + 1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Fixed Length Opaque into an XDR

  returns the resulted XDR
  """
  @spec encode_xdr!(xdr :: binary(), length :: integer()) :: binary()
  def encode_xdr!(xdr, length), do: encode_xdr(xdr, length) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Fixed Length Opaque

  returns an :ok tuple with the resulted binary
  """
  @spec decode_xdr(binary, integer) :: {:ok, {binary, binary}}
  def decode_xdr(xdr, _length) when not is_binary(xdr), do: raise(FixedOpaqueErr, :not_binary)

  def decode_xdr(xdr, _length) when rem(byte_size(xdr), 4) != 0,
    do: raise(FixedOpaqueErr, :not_valid_binary)

  def decode_xdr(_xdr, length) when not is_integer(length), do: raise(FixedOpaqueErr, :not_number)

  def decode_xdr(xdr, length) when length > byte_size(xdr),
    do: raise(FixedOpaqueErr, :exceed_length)

  def decode_xdr(xdr, length) do
    required_padding = get_required_padding(length)
    <<opaque::bytes-size(length), _padding::bytes-size(required_padding), rest::binary>> = xdr
    {:ok, {opaque, rest}}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Fixed Length Opaque

  returns the resulted binary
  """
  @spec decode_xdr!(xdr :: binary(), length :: integer()) :: {binary(), binary()}
  def decode_xdr!(xdr, length), do: decode_xdr(xdr, length) |> elem(1)

  @spec get_required_padding(integer()) :: integer()
  defp get_required_padding(length) when rem(length, 4) == 0, do: 0
  defp get_required_padding(length), do: 4 - rem(length, 4)
end
