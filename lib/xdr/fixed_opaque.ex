defmodule XDR.FixedOpaque do
  @moduledoc """
  This module is in charge of process the Fixed Length Opaque based on the RFC4506 XDR Standard
  """
  @behaviour XDR.Declaration

  defstruct opaque: nil, length: nil

  @typedoc """
  Every Fixed length opaque structure has a opaque which represent the XDR to fix and its length
  """
  @type t :: %XDR.FixedOpaque{opaque: binary, length: integer}

  alias XDR.Error.FixedOpaque, as: FixedOpaqueErr

  @doc """
  this function provides an easy way to create an XDR.FixedOpaque type

  returns a XDR.FixedOpaque struct with the value received as parameter
  """
  @spec new(opaque :: binary, length :: integer) :: t()
  def new(opaque, length), do: %XDR.FixedOpaque{opaque: opaque, length: length}

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Fixed Length Opaque into an XDR, it receives an XDR.FixedOpaque structure which
  contains the bytes to encode

  returns an ok tuple with the resulted XDR
  """
  @spec encode_xdr(t()) :: {:ok, binary}
  def encode_xdr(%XDR.FixedOpaque{opaque: opaque}) when not is_binary(opaque),
    do: raise(FixedOpaqueErr, :not_binary)

  def encode_xdr(%XDR.FixedOpaque{length: length}) when not is_integer(length),
    do: raise(FixedOpaqueErr, :not_number)

  def encode_xdr(%XDR.FixedOpaque{opaque: opaque, length: length})
      when length != byte_size(opaque),
      do: raise(FixedOpaqueErr, :invalid_length)

  def encode_xdr(%XDR.FixedOpaque{opaque: opaque, length: length}) when rem(length, 4) === 0,
    do: {:ok, opaque}

  def encode_xdr(%XDR.FixedOpaque{opaque: opaque, length: length}) when rem(length, 4) != 0 do
    new(opaque <> <<0>>, length + 1)
    |> encode_xdr()
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of encode a Fixed Length Opaque into an XDR, it receives an XDR.FixedOpaque structure which
  contains the bytes to encode

  returns the resulted XDR
  """
  @spec encode_xdr!(t()) :: binary()
  def encode_xdr!(opaque), do: encode_xdr(opaque) |> elem(1)

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Fixed Length Opaque, it receives an XDR.FixedOpaque structure which
  contains the binary to decode

  returns an :ok tuple with the resulted binary
  """
  @spec decode_xdr(t()) :: {:ok, {binary, binary}}
  def decode_xdr(%XDR.FixedOpaque{opaque: opaque}) when not is_binary(opaque),
    do: raise(FixedOpaqueErr, :not_binary)

  def decode_xdr(%XDR.FixedOpaque{opaque: opaque}) when rem(byte_size(opaque), 4) != 0,
    do: raise(FixedOpaqueErr, :not_valid_binary)

  def decode_xdr(%XDR.FixedOpaque{length: length}) when not is_integer(length),
    do: raise(FixedOpaqueErr, :not_number)

  def decode_xdr(%XDR.FixedOpaque{opaque: opaque, length: length})
      when length > byte_size(opaque),
      do: raise(FixedOpaqueErr, :exceed_length)

  def decode_xdr(%XDR.FixedOpaque{opaque: opaque, length: length}) do
    required_padding = get_required_padding(length)

    <<fixed_opaque::bytes-size(length), _padding::bytes-size(required_padding), rest::binary>> =
      opaque

    {:ok, {fixed_opaque, rest}}
  end

  @impl XDR.Declaration
  @doc """
  this function is in charge of decode an XDR into a Fixed Length Opaque, it receives an XDR.FixedOpaque structure which
  contains the binary to decode

  returns the resulted binary
  """
  @spec decode_xdr!(t()) :: {binary(), binary()}
  def decode_xdr!(opaque), do: decode_xdr(opaque) |> elem(1)

  @spec get_required_padding(integer()) :: integer()
  defp get_required_padding(length) when rem(length, 4) == 0, do: 0
  defp get_required_padding(length), do: 4 - rem(length, 4)
end