defmodule XDR.HyperUInt do
  @moduledoc """
  This module is in charge of process the Hyper Unsigned Integer types based on the RFC4056 XDR Standard
  """
  alias XDR.Error.HyperUInt

  @behaviour XDR.Declaration

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Unsigned Integer received by parameter if the parameters
  are wrong an error will be raised

    ## Parameters:
      -value: represents the Hyper Unsigned Integer value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the XDR resulted from encoding the Hyper Unsigned Integer value
  """
  @spec encode_xdr(integer(), any) :: {:ok, binary()}
  def encode_xdr(value, opts \\ nil)
  def encode_xdr(value, _opts) when not is_integer(value), do: raise(HyperUInt, :not_integer)

  def encode_xdr(value, _opts) when value > 18_446_744_073_709_551_615,
    do: raise(HyperUInt, :exceed_upper_limit)

  def encode_xdr(value, _opts) when value < 0, do: raise(HyperUInt, :exceed_lower_limit)
  def encode_xdr(value, _opts), do: {:ok, <<value::big-unsigned-integer-size(64)>>}

  @impl XDR.Declaration
  @doc """
  This function is in charge of encoding the Hyper Unsigned Integer received by parameter if the parameters
  are wrong an error will be raised

    ## Parameters:
      -value: represents the Hyper Unsigned Integer value which needs to encode
      -opts: it is an optional value required by the behaviour

  Returns the XDR resulted from encoding the Hyper Unsigned Integer value
  """
  @spec encode_xdr!(integer(), any) :: binary()
  def encode_xdr!(value, opts \\ nil)
  def encode_xdr!(value, _opts), do: encode_xdr(value) |> elem(1)

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Unsigned Integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an Hyper Unsigned Integer
      -opts: it is an optional value required by the behaviour

  Returns a tuple with the Hyper Unsigned Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr(binary(), any()) :: {:ok, {integer(), binary()}}
  def decode_xdr(bytes, opts \\ nil)
  def decode_xdr(bytes, _opts) when not is_binary(bytes), do: raise(HyperUInt, :not_binary)

  def decode_xdr(<<hyper_int::big-unsigned-integer-size(64), rest::binary>>, _opts),
    do: {:ok, {hyper_int, rest}}

  @impl XDR.Declaration
  @doc """
  This function is in charge of decode the XDR value which represents an Hyper Unsigned Integer value if the parameters are wrong
  an error will be raised

    ## Parameters:
      -bytes: represents the XDR value which needs to decode into an Hyper Unsigned Integer
      -opts: it is an optional value required by the behaviour

  Returns the Hyper Unsigned Integer resulted from decode the XDR value and its remaining bits
  """
  @spec decode_xdr!(binary(), any()) :: {integer(), binary()}
  def decode_xdr!(bytes, opts \\ nil)
  def decode_xdr!(binary, _opts), do: decode_xdr(binary) |> elem(1)
end
